//
//  Audio.swift
//  AirAP
//
//  Created by neon443 on 17/05/2025.
//

import Foundation
import AudioToolbox

class CoreAudioPlayer {
	private var audioQueue: AudioQueueRef?
	private let bufferCount = 3
	private var audioBuffers: [AudioQueueBufferRef] = []
	private let bufferSize: UInt32 = 4096
	
	init() {
		var format = AudioStreamBasicDescription(
			mSampleRate: 44100,
			mFormatID: kAudioFormatLinearPCM,
			mFormatFlags: kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked,
			mBytesPerPacket: 4,
			mFramesPerPacket: 1,
			mBytesPerFrame: 4,
			mChannelsPerFrame: 2,
			mBitsPerChannel: 16,
			mReserved: 0
		)
		
		let status = AudioQueueNewOutput(
			&format,
			outputCallback,
			Unmanaged.passUnretained(self).toOpaque(),
			nil,
			nil,
			0,
			&audioQueue
		)
		
		if status != noErr {
			print("audioqueoutput failure \(status)")
			return
		}
		
		for _ in 0..<bufferCount {
			var bufferRef: AudioQueueBufferRef?
			let result = AudioQueueAllocateBuffer(audioQueue!, bufferSize, &bufferRef)
			if result == noErr, let buf = bufferRef {
				audioBuffers.append(buf)
			}
		}
		
		AudioQueueStart(audioQueue!, nil)
		print("start audio queue")
	}
	
	func playAudio(_ audio: UnsafePointer<UInt16>, byteCount: Int) {
		guard let queue = audioQueue else {
			return
		}
		
		guard let buffer = audioBuffers.popLast() else {
			return
		}
		
		memcpy(buffer.pointee.mAudioData, audio, byteCount)
		buffer.pointee.mAudioDataByteSize = UInt32(byteCount)
		print("Buffer size: \(buffer.pointee.mAudioDataByteSize)")
		
		let err = AudioQueueEnqueueBuffer(queue, buffer, 0, nil)
		if err != noErr {
			print("failed to queue \(err)")
		} else {
			audioBuffers.insert(buffer, at: 0) //reuse
		}
	}
}

func outputCallback (
	_ userData: UnsafeMutableRawPointer?,
	_ queue: AudioQueueRef,
	_ buffer: AudioQueueBufferRef
) {
	print("called back")
}
