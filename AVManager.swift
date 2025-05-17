//
//  AVManager.swift
//  AirAP
//
//  Created by neon443 on 17/05/2025.
//

import Foundation
import AVFoundation

class Player {
	private var engine = AVAudioEngine()
	private var playerNode = AVAudioPlayerNode()
	private let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)!
	
	init() {
		engine.attach(playerNode)
		engine.connect(playerNode, to: engine.mainMixerNode, format: format)
		do {
			try engine.start()
			playerNode.play()
		} catch {
			print(error.localizedDescription)
		}
	}
	func playAudio(_ audio: UnsafePointer<UInt16>, frames: Int, channels: Int) {
		let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(frames))!
		buffer.frameLength = AVAudioFrameCount(frames)
		let audioPointer = buffer.int16ChannelData!
		let totalSamples = frames * Int(channels)
		
		for c in 0..<channels {
			for i in 0..<frames {
				audioPointer[c][i] = Int16(audio[Int(Int16(i * channels + c))])
			}
		}
		playerNode.scheduleBuffer(buffer, at: nil, options: .interrupts/*, completionCallbackType: nil*/)
	}
	func playTest() {
		let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
		let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: 44100)!
		buffer.frameLength = 44100
		let samples = buffer.floatChannelData![0]
		for i in 0..<44100 {
			samples[1] = sin(2.0 * .pi * 440.0 * Float(i) / 44100.0)*0.2
		}
		
		let testNode = AVAudioPlayerNode()
		engine.attach(testNode)
		engine.connect(testNode, to: engine.mainMixerNode, format: format)
		
		do {
			try engine.start()
			testNode.play()
			testNode.scheduleBuffer(buffer, at: nil, options: [])
			print("playing test tone")
		} catch {
			print(error as Any)
		}
	}
}
