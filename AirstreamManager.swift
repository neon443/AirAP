//
//  AirstreamManager.swift
//  AirAP
//
//  Created by neon443 on 16/05/2025.
//

import Foundation
import Airstream

class AirstreamManager: NSObject, ObservableObject, AirstreamDelegate {
	private var airstream: Airstream?
	
	@Published var metadata: [String: String] = [:]
	
	override init() {
		super.init()
		airstream = Airstream(name: "airstream")
		airstream?.delegate = self
		airstream?.startServer()
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
}
