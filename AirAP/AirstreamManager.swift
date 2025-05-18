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
	private var player = CoreAudioPlayer()
	@Published var coverArt: UIImage?
	
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
		processAudio buffer: UnsafeMutablePointer<Int8>,
		length: Int32
	) {
		player.playAudio(buffer, byteCount: Int(length))
	}
	
	func airstreamFlushAudio(_ airstream: Airstream) {
//		player = nil
	}
	
	func airstream(_ airstream: Airstream, didSetCoverart coverart: Data) {
		print(coverart)
		if let image = UIImage(data: coverart) {
			coverArt = image
		}
	}
}
