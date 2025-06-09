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
import SwiftUI

class AirstreamManager: NSObject, ObservableObject, AirstreamDelegate {
	@Published var airstream: Airstream?
	
	@Published var settings: AAPSettingsModel

	var audioUnit: AudioComponentInstance?
	var circularBuffer = TPCircularBuffer()
	var buffering: Bool = false
	
	private let userdefaults = UserDefaults(suiteName: "group.neon443.AirAP") ?? UserDefaults.standard
	
	@Published var running = false
	@Published var name: String = UIDevice.current.name
	@Published var canControl = false
	
	@Published var title: String?
	@Published var album: String?
	@Published var artist: String?
	@Published var albumArt: UIImage?
	
	override init() {
		self.settings = AAPSettingsModel()
		super.init()
		_TPCircularBufferInit(&circularBuffer, 131_072, MemoryLayout.size(ofValue: circularBuffer))
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
		airstream = Airstream(name: name)
		airstream?.delegate = self
		airstream?.startServer()
		withAnimation {
			running = true
		}
		try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
		try? AVAudioSession.sharedInstance().setActive(true)
	}
	
	func stop() {
		
		airstream?.stopServer()
		withAnimation {
			running = false
			clearMetadata()
		}
	}
	
	func startStop() {
		switch running {
		case true:
			stop()
		case false:
			start()
		}
	}
	
	func clearMetadata() {
		albumArt = nil
		title = nil
		album = nil
		artist = nil
	}
	
	//brefore stream setup
	func airstream(_ airstream: Airstream, willStartStreamingWithStreamFormat streamFormat: AudioStreamBasicDescription) {
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
		//MARK: add volume changing later
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
		
		self.buffering = TPCircularBufferFillCount(&circularBuffer) < 8192
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
		withAnimation {
			albumArt = uiimage
		}
	}
	
	//recieved track info
	func airstream(_ airstream: Airstream, didSetMetadata metadata: [String : String]) {		
		withAnimation {
			title = metadata["minm"] //??
			album = metadata["asal"] //airstream album
			artist = metadata["asar"] //airstream artist
		}
	}
	
	func airstream(_ airstream: Airstream, didGainAccessTo remote: AirstreamRemote) {
		withAnimation {
			canControl = true
		}
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
