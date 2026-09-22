//
//  AirstreamManager.swift
//  AirAP
//
//  Created by neon443 on 16/05/2025.
//

import Foundation
import Airstream
import AVFoundation
import UIKit

class AirstreamManager: NSObject, AirstreamDelegate {
	static let shared = AirstreamManager()
	var airstream: Airstream?
	
	var settings: AAPSettings

	var audioUnit: AudioComponentInstance?
	var circularBuffer = TPCircularBuffer()
	var buffering: Bool = false
	
	private let userdefaults = UserDefaults(suiteName: "group.neon443.AirAP") ?? UserDefaults.standard
	
	var canControl = false
	
	/// Minimum amount of audio (in bytes) that must be present in the circular buffer before we
	/// allow CoreAudio to start rendering.
	/// The default value corresponds to ~2 s of 44.1 kHz, 16-bit, stereo PCM (44 100 * 1 s * 4 B).
	private var minBufferBytes: Int32 = 176_000
	private var targetLatencySeconds: Double  { Double(settings.delay) }
	
	var title: String?
	var album: String?
	var artist: String?
	var albumArt: UIImage?
	
	var didSetAlbumArt: (() -> Void)?
	var didSetMetadata: (() -> Void)?
	var updatePosition: ((Float, Float) -> Void)?
	var updateVolume: ((Float) -> Void)?
	
	override init() {
		self.settings = .init()
		super.init()
		// 1 mib circular buffer
		// hold minBufferBytes is ~350 kb
		_TPCircularBufferInit(&circularBuffer, 1_048_576, MemoryLayout.size(ofValue: circularBuffer))
		airstream = Airstream(name: settings.name, password: settings.password)
		airstream?.delegate = self
		start()
	}
	
	deinit {
		//MARK: REFACTOR THIS LATER
		TPCircularBufferClear(&circularBuffer)
		
		//stop audio unit
		if let audioUnit = audioUnit {
			let status = AudioOutputUnitStop(audioUnit)
			if status != noErr {
				print("failed to stop audio unit")
			}
		}
		audioUnit = nil
	}
	
	func start() {
		airstream?.startServer()
		try? AVAudioSession.sharedInstance().setCategory(.playback)
		try? AVAudioSession.sharedInstance().setActive(true)
	}
	
	func stop() {
		airstream?.stopServer()
		cleanup()
		try? AVAudioSession.sharedInstance().setActive(false)
	}
	
	func startStop() {
		switch airstream!.running {
		case true:
			stop()
		case false:
			start()
		}
	}
	
	func cleanup() {
		clearMetadata()
		clearSliders()
	}
	
	func clearMetadata() {
		albumArt = nil
		title = nil
		album = nil
		artist = nil
		didSetAlbumArt?()
		didSetMetadata?()
	}
	
	func clearSliders() {
		if let airstream = airstream,
		   let delegate = airstream.delegate {
			delegate.airstream?(airstream, didSetVolume: 0)
			delegate.airstream?(airstream, didSetPosition: 0, duration: 0)
		}
	}
	
	//brefore stream setup
	func airstream(_ airstream: Airstream, willStartStreamingWithStreamFormat streamFormat: AudioStreamBasicDescription) {
		// Set a ~2s buffer based on the negotiated stream format.
		let bytesPerFrame = Double(streamFormat.mBytesPerFrame)
		let bytesPerSecond = streamFormat.mSampleRate * bytesPerFrame
		minBufferBytes = Int32(bytesPerSecond * targetLatencySeconds)
		// Ensure we start in buffering mode.
		self.buffering = true
		
		var streamFormat = streamFormat
		//create audio component
		#if canImport(AppKit)
		var desc = AudioComponentDescription(
			componentType: kAudioUnitType_Output,
			componentSubType: kAudioUnitSubType_DefaultOutput, //OS X only
			componentManufacturer: kAudioUnitManufacturer_Apple,
			componentFlags: 0,
			componentFlagsMask: 0
		)
		#elseif canImport(UIKit)
		var desc = AudioComponentDescription(
			componentType: kAudioUnitType_Output,
			componentSubType: kAudioUnitSubType_RemoteIO,
			componentManufacturer: kAudioUnitManufacturer_Apple,
			componentFlags: 0,
			componentFlagsMask: 0
		)
		#endif
		if let comp = AudioComponentFindNext(nil, &desc) {
			let status = AudioComponentInstanceNew(comp, &audioUnit)
			if status != noErr {
				print("error creating new audio component instance new")
				print(status)
				return
			}
		}
		
		guard let audioUnit = audioUnit else { return }
		
		//enable input
		let status = AudioUnitSetProperty(
			audioUnit,
			kAudioUnitProperty_StreamFormat,
			kAudioUnitScope_Input,
			0,
			&streamFormat,
			UInt32(MemoryLayout.size(ofValue: streamFormat))
		)
		if status != noErr {
			print("error enabling input")
			print(status)
			return
		}
		
		//setup callbacks
		var renderCallback: AURenderCallbackStruct = AURenderCallbackStruct(
			inputProc: OutputRenderCallback,
			inputProcRefCon: Unmanaged.passUnretained(self).toOpaque()
		)
		let setupStatus = AudioUnitSetProperty(
			audioUnit,
			kAudioUnitProperty_SetRenderCallback,
			kAudioUnitScope_Global,
			0,
			&renderCallback,
			UInt32(MemoryLayout.size(ofValue: renderCallback))
		)
		if setupStatus != noErr {
			print("failed to setup callbacks")
			print(setupStatus)
			return
		}
		
		//init audio unit
		let initStatus = AudioUnitInitialize(audioUnit)
		if initStatus != noErr {
			print("failed to init audio unit")
			print(initStatus)
			return
		}
		
		//start audio unit
		let unitStatus = AudioOutputUnitStart(audioUnit)
		if unitStatus != noErr {
			print("failed to start audio unit")
			print(unitStatus)
			return
		}
	}
	
	//here's some audio
	func airstream(
		_ airstream: Airstream,
		processAudio buffer: UnsafeMutablePointer<CChar>,
		length: Int32
	) {
		DispatchQueue.main.async {
			self.updatePosition?(
				Float(airstream.position),
				Float(airstream.duration)
			)
		}
		
		if airstream.volume < 1 {
			buffer.withMemoryRebound(to: CShort.self, capacity: Int(length)/2) { pointer in
				for i in 0 ..< Int(length)/2 {
					pointer[i] = CShort(Float(pointer[i]) * airstream.volume)
				}
			}
		}
		
		let audioBuffer = AudioBuffer(
			mNumberChannels: UInt32(airstream.channelsPerFrame),
			mDataByteSize: UInt32(length),
			mData: buffer
		)
		let bufferList = AudioBufferList(
			mNumberBuffers: 1,
			mBuffers: audioBuffer
		)
		
		TPCircularBufferProduceBytes(
			&circularBuffer,
			bufferList.mBuffers.mData,
			bufferList.mBuffers.mDataByteSize
		)
		
		//are we falling behind? checks if buffering is needed
		let fillCount = TPCircularBufferFillCount(&circularBuffer)
		self.buffering = fillCount < minBufferBytes
	}
	
	//bro stopped airplaying
	func airstreamDidStopStreaming(_ airstream: Airstream) {
		TPCircularBufferClear(&circularBuffer)
		
		//stop audio unit
		if let audioUnit = audioUnit {
			let status = AudioOutputUnitStop(audioUnit)
			if status != noErr {
				print("failed to stop audio unit")
			}
		}
		audioUnit = nil
	}
	
	//recieved cover art
	func airstream(_ airstream: Airstream, didSetCoverart coverart: Data) {
		guard let uiimage = UIImage(data: coverart) else {
			albumArt = nil
			return
		} //con only if the data is an image
		guard uiimage != albumArt else { return } //con only if album art is diff
		albumArt = uiimage
		didSetAlbumArt?()
	}
	
	//recieved track info
	func airstream(_ airstream: Airstream, didSetMetadata metadata: [String : String]) {		
		title = metadata[ASMetadataSongTitleKey]
		album = metadata[ASMetadataSongAlbumKey]
		artist = metadata[ASMetadataSongArtistKey]
		didSetMetadata?()
	}
	
	func airstream(_ airstream: Airstream, didSetVolume volume: Float) {
		DispatchQueue.main.async {
			self.updateVolume?(airstream.volume)
		}
	}
	
	func airstream(_ airstream: Airstream, didSetPosition position: UInt, duration: UInt) {
		DispatchQueue.main.async {
			self.updatePosition?(
				Float(position),
				Float(duration)
			)
		}
	}
	
	func airstream(_ airstream: Airstream, didGainAccessTo remote: AirstreamRemote) {
		canControl = true
	}
	
	let OutputRenderCallback: AURenderCallback = { (
		inRefCon,
		ioActionFlags,
		inTimeStamp,
		inBusNumber,
		inNumberFrames,
		ioData
	) in
		let manager = Unmanaged<AirstreamManager>.fromOpaque(inRefCon).takeUnretainedValue()
		
		if TPCircularBufferFillCount(&manager.circularBuffer) == 0 || manager.buffering {
			//TODO: fixme
//			i think its just best to return???
			for i in 0..<Int(ioData!.pointee.mNumberBuffers) {
				memset(
					ioData!.pointee.mBuffers.mData,
					0,
					Int(ioData!.pointee.mBuffers.mDataByteSize)
				)
			}
			return noErr
		}
		
		var availableBytes: UInt32 = 0
		let sourceBuffer = TPCircularBufferTail(&manager.circularBuffer, &availableBytes)
		let amount = min(ioData!.pointee.mBuffers.mDataByteSize, availableBytes)
		
		//copy audio from our circ buffer to audio unit's buffer
		memcpy(ioData!.pointee.mBuffers.mData, sourceBuffer, Int(amount))
		
		TPCircularBufferConsume(&manager.circularBuffer, amount)
		
		return noErr
	}
}
