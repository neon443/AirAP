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
}
