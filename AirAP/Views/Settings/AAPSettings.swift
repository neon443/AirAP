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
	var bgOpacity: CGFloat
	var bgBlur: CGFloat
	var showMetadata: Bool
	var showAudioQuality: Bool
}

class AAPSettingsModel: ObservableObject {
	@Published var name: String = UIDevice().model
	@Published var showBg: Bool = true
	@Published var bgOpacity: CGFloat = 0.8
	@Published var bgBlur: CGFloat = 75
	@Published var showMetadata: Bool = true
	@Published var showAudioQuality: Bool = true
	
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
		objectWillChange.send()
	}
}
