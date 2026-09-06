//
//  AAPSettings.swift
//  AirAP
//
//  Created by neon443 on 25/05/2025.
//

import Foundation
import UIKit

struct AAPSettings: Codable {
	var name: String
	var showBg: Bool
	var bgOpacity: Float
	var bgBlur: Float
	var showMetadata: Bool
	var showAudioQuality: Bool
	var delay: Float
}

class AAPSettingsModel {
	var name: String = "AirAP"
	var showBg: Bool = true
	var bgOpacity: Float = 0.8
	var bgBlur: Float = 75
	var showMetadata: Bool = true
	var showAudioQuality: Bool = true
	var delay: Float = 0
	
	private let userdefaults = UserDefaults(suiteName: "group.neon443.AirAP") ?? UserDefaults.standard
	
	init() {
		loadSettings()
	}
	
	func loadSettings() {
		guard let data = userdefaults.data(forKey: "settings") else { return }
		
		let decoder = JSONDecoder()
		if let decoded = try? decoder.decode(AAPSettings.self, from: data) {
			name = decoded.name
			showBg = decoded.showBg
			bgOpacity = decoded.bgOpacity
			bgBlur = decoded.bgBlur
			showMetadata = decoded.showMetadata
			showAudioQuality = decoded.showAudioQuality
			delay = decoded.delay
		}
	}
	
	func saveSettings() {
		let encoder = JSONEncoder()
		let settings = AAPSettings(
			name: name,
			showBg: showBg,
			bgOpacity: bgOpacity,
			bgBlur: bgBlur,
			showMetadata: showMetadata,
			showAudioQuality: showAudioQuality,
			delay: delay
		)
		if let encoded = try? encoder.encode(settings) {
			userdefaults.set(encoded, forKey: "settings")
		}
	}
}
