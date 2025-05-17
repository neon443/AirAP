//
//  ContentView.swift
//  AirAP
//
//  Created by neon443 on 16/05/2025.
//

import SwiftUI
import Airstream

struct ContentView: View {
	@StateObject var ASmanager = AirstreamManager()
	init() {
//		let pl = Player2()
		let p = Player()
		p.playTest()
	}
    var body: some View {
        VStack {
			Text(" ")
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}


import AVFoundation

class Player2 {
	private var engine = AVAudioEngine()
	private var playerNode = AVAudioPlayerNode()
	
	init() {
		let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
		
		engine.attach(playerNode)
		engine.connect(playerNode, to: engine.mainMixerNode, format: format)
		
		do {
			try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
			try AVAudioSession.sharedInstance().setActive(true)
			try engine.start()
			print("✅ Audio engine started")
		} catch {
			print("❌ Audio setup failed: \(error)")
			return
		}
		
		// Generate sine wave
		let frameCount = 44100 // 1 second
		let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(frameCount))!
		buffer.frameLength = AVAudioFrameCount(frameCount)
		
		let samples = buffer.floatChannelData![0]
		for i in 0..<Int(buffer.frameLength) {
			let sample = sin(2.0 * .pi * 440.0 * Float(i) / 44100.0) * 0.3
			samples[i] = sample
		}
		
		playerNode.play()
		playerNode.scheduleBuffer(buffer, at: nil, options: []) {
			print("✅ Done playing tone")
		}
	}
}
