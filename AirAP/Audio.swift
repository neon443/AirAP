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
	private let bufferCount = 64
	private var audioBuffers: [AudioQueueBufferRef] = []
	private let bufferSize: UInt32 = 16_384
	private let bufferQueue = DispatchQueue(label: "audio.buffer.q")
	
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
				bufferQueue.sync {
					audioBuffers.append(buf)
				}
			}
		}
		
		let startStatus = AudioQueueStart(audioQueue!, nil)
		if startStatus != noErr {
			print("failed to start queue \(startStatus)")
		} else {
			print("start audio queu sucess")
		}
	}
	
	func playAudio(_ audio: UnsafePointer<Int8>, byteCount: Int) {
		guard let queue = audioQueue else {
			return
		}
		
		guard let buffer = bufferQueue.sync(
			execute: {
				audioBuffers.popLast()
			}
		) else {
//			print("buffer poplast failed")
			return
		}
		
		memcpy(buffer.pointee.mAudioData, audio, byteCount)
		buffer.pointee.mAudioDataByteSize = UInt32(byteCount)
//		print("Buffer size: \(buffer.pointee.mAudioDataByteSize)")
		
		let err = AudioQueueEnqueueBuffer(queue, buffer, 0, nil)
		if err != noErr {
			print("failed to queue \(err)")
		} else {
			//MARK: dont immediatley reuse
//			audioBuffers.insert(buffer, at: 0) //reuse
		}
	}
	
	func stop() {
		if let queue = audioQueue {
			AudioQueueStop(queue, true)
			AudioQueueDispose(queue, true)
			print("stopped and dispreosed que")
		}
		bufferQueue.sync {
			audioBuffers.removeAll()
		}
	}
	
	func recycleBuffer(_ buffer: AudioQueueBufferRef) {
		bufferQueue.sync {
			audioBuffers.append(buffer)
		}
	}
}

func outputCallback (
	_ userData: UnsafeMutableRawPointer?,
	_ queue: AudioQueueRef,
	_ buffer: AudioQueueBufferRef
) {
	guard let userData = userData else { return }
	let player = Unmanaged<CoreAudioPlayer>.fromOpaque(userData).takeUnretainedValue()
	player.recycleBuffer(buffer)
}
