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
	private var airstream: Airstream?
	
	@Published var metadata: [String: String] = [:]
	
	override init() {
		super.init()
		airstream = Airstream(name: "airstream")
		airstream?.delegate = self
		airstream?.startServer()
		try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
		try? AVAudioSession.sharedInstance().setActive(true)
	}
	
	func airstream(_ airstream: Airstream, didSetVolume volume: Float) {
		DispatchQueue.main.async {
			print("set vol here")
//			self.airstream?.volume = volume
		}
	}
	
	func stop() {
		airstream?.stopServer()
	}
	let player = Player()
	func airstream(_ airstream: Airstream, didReceiveAudio audio: UnsafePointer<UInt16>, frames: Int, channels: Int) {
		player.playAudio(audio, frames: frames, channels: channels)
		print("hoo")
	}
}
