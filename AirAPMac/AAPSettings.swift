//
//  AAPSettings.swift
//  AirAPMac
//
//  Created by neon443 on 03/11/2025.
//

import Foundation
import Combine
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

struct AAPSettings: Codable {
	var name: String
	var showBg: Bool
	var bgOpacity: CGFloat
	var bgBlur: CGFloat
	var showMetadata: Bool
	var showAudioQuality: Bool
}

class AAPSettingsModel {
	var name: String = "AirAP"
	var showBg: Bool = true
	var bgOpacity: CGFloat = 0.8
	var bgBlur: CGFloat = 75
	var showMetadata: Bool = true
	var showAudioQuality: Bool = true
	
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
			showAudioQuality: showAudioQuality
		)
		if let encoded = try? encoder.encode(settings) {
			userdefaults.set(encoded, forKey: "settings")
		}
	}
}
