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

class AirstreamManager: NSObject, ObservableObject, AirstreamDelegate {
	@Published var airstream: Airstream?
	private var player = CircularBuffer()
	@Published var coverArt: UIImage?
	var audioUnit: AudioComponentInstance?
	var circularBuffer = TPCircularBuffer()
	
	var buffering: Bool = false
	var art: UIImage?
	var title: String = ""
	var album: String = ""
	var artist: String = ""
	var canControl = false
	
	override init() {
		super.init()
		_TPCircularBufferInit(&circularBuffer, 131_072, MemoryLayout.size(ofValue: circularBuffer))
		airstream = Airstream(name: "airstream")
		airstream?.delegate = self
		airstream?.startServer()
		try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
		try? AVAudioSession.sharedInstance().setActive(true)
	}
	
	deinit {
		//MARK: REFACTOR THIS LATER
		TPCircularBufferClear(&circularBuffer)
		
		//stop audio unit
		let status = AudioOutputUnitStop(audioUnit!)
		if status != noErr {
			print("failed to stop audio unit")
		}
		audioUnit = nil
	}
	
	//brefore stream setup
	func airstream(_ airstream: Airstream, willStartStreamingWithStreamFormat streamFormat: AudioStreamBasicDescription) {
		var streamFormat = streamFormat
		
		//create audio component
		var desc = AudioComponentDescription(
			componentType: kAudioUnitType_Output,
			componentSubType: kAudioUnitSubType_RemoteIO,
			//componentSubType: kAudioUnitSubType_DefaultOutput, //OS X only :cry
			componentManufacturer: kAudioUnitManufacturer_Apple,
			componentFlags: 0,
			componentFlagsMask: 0
		)
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
		//MARK: add volume changing later
		//		if airstream.volume < 1.0 {
		//			var shortData = buffer.pointee/*.bindMemory(to: Int16.self, capacity: length / MemoryLayout<Int16>.stride)*/
		//			var shortData = buffer.pointee.
		//			let length = Int(length)
		//			shortData *= Int8(airstream.volume)
		//		}
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
			Int32(bufferList.mBuffers.mDataByteSize)
		)
		
		//are we falling behind? checks if buffering is needed
		self.buffering = circularBuffer.fillCount < 8192
	}
	
	//bro stopped airplaying
	func airstreamDidStopStreaming(_ airstream: Airstream) {
		TPCircularBufferClear(&circularBuffer)
		
		//stop audio unit
		let status = AudioOutputUnitStop(audioUnit!)
		if status != noErr {
			print("failed to stop audio unit")
		}
		audioUnit = nil
	}
	
	//recieved cover art
	func airstream(_ airstream: Airstream, didSetCoverart coverart: Data) {
		art = UIImage(data: coverart)
	}
	
	//recieved track info
	func airstream(_ airstream: Airstream, didSetMetadata metadata: [String : String]) {
		print(metadata)
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
		if manager.circularBuffer.fillCount == 0 || manager.buffering {
			//MARK: FIXXX
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
		
		TPCircularBufferConsume(&manager.circularBuffer, Int32(amount))
		
		return noErr
	}
}
