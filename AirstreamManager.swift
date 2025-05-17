//
//  AirstreamManager.swift
//  AirAP
//
//  Created by neon443 on 16/05/2025.
//

import Foundation
import Airstream
import AVFoundation

class AirstreamManager: NSObject, ObservableObject, AirstreamDelegate {
	@Published var airstream: Airstream?
	private let player = CoreAudioPlayer()
	
	@Published var metadata: [String: String] = [:]
	
	override init() {
		super.init()
		airstream = Airstream(name: "airstream")
		airstream?.delegate = self
		airstream?.startServer()
		try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
		try? AVAudioSession.sharedInstance().setActive(true)
	}
	
//	func airstream(_ airstream: Airstream, didSetVolume volume: Float) {
//		DispatchQueue.main.async {
//			print("set vol here")
//		}
//	}
	
	func stop() {
		airstream?.stopServer()
	}
	func airstream(
		_ airstream: Airstream,
		didReceiveAudio audio: UnsafePointer<UInt16>,
		frames: Int,
		channels: Int
	) {
		let byteCount = frames * channels * MemoryLayout<UInt16>.size
		player.playAudio(audio, byteCount: byteCount)
	}
}
