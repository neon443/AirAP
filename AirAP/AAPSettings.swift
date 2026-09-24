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
	var keepAwake: Bool
	var password: String?
	var showBg: Bool
	var bgOpacity: Float
	var bgBlur: AAPSettings.bgBlurStrengths
	var showMetadata: Bool
	var showAudioQuality: Bool
	var delay: Float
	
	private static let userDefaults = UserDefaults(suiteName: "group.neon443.AirAP") ?? UserDefaults.standard
	
	enum bgBlurStrengths: Int, CaseIterable, Codable, CustomStringConvertible {
		case systemUltraThinMaterial = 0
		case systemThinMaterial = 1
		case systemChromeMaterial = 2
		case systemMaterial = 3
		
		var uiBlurEffectStyle: UIBlurEffect.Style {
			switch self {
			case .systemUltraThinMaterial:
				return .systemUltraThinMaterialSafe
			case .systemThinMaterial:
				return .systemThinMaterialSafe
			case .systemChromeMaterial:
				return .systemChromeMaterialSafe
			case .systemMaterial:
				return .systemMaterialSafe
			}
		}
		
		var description: String {
			switch self {
			case .systemUltraThinMaterial:
				return "Very Low"
			case .systemThinMaterial:
				return "Low"
			case .systemChromeMaterial:
				return "Medium"
			case .systemMaterial:
				return "High"
			}
		}
	}
	
	init(
		name: String,
		keepAwake: Bool,
		password: String? = nil,
		showBg: Bool,
		bgOpacity: Float,
		bgBlur: AAPSettings.bgBlurStrengths,
		showMetadata: Bool,
		showAudioQuality: Bool,
		delay: Float
	) {
		self.name = name
		self.keepAwake = keepAwake
		self.password = password
		self.showBg = showBg
		self.bgOpacity = bgOpacity
		self.bgBlur = bgBlur
		self.showMetadata = showMetadata
		self.showAudioQuality = showAudioQuality
		self.delay = delay
	}
	
	init(clean: Bool = false) {
		let decoder = JSONDecoder()
		
		guard let data = AAPSettings.userDefaults.data(forKey: "settings"),
			  let decoded = try? decoder.decode(AAPSettings.self, from: data),
			  clean == false else {
			self.name = "AirAP"
			self.keepAwake = false
			self.password = nil
			self.showBg = true
			self.bgOpacity = 0.8
			self.bgBlur = .systemUltraThinMaterial
			self.showMetadata = true
			self.showAudioQuality = false
			self.delay = 0
			return
		}
		
		self.name = decoded.name
		self.keepAwake = decoded.keepAwake
		self.password = decoded.password
		self.showBg = decoded.showBg
		self.bgOpacity = decoded.bgOpacity
		self.bgBlur = decoded.bgBlur
		self.showMetadata = decoded.showMetadata
		self.showAudioQuality = decoded.showAudioQuality
		self.delay = decoded.delay
		
		UIApplication.shared.isIdleTimerDisabled = keepAwake
	}
	
	func saveSettings() {
		let encoder = JSONEncoder()
		if let encoded = try? encoder.encode(self) {
			AAPSettings.userDefaults.set(encoded, forKey: "settings")
		}
	}
	
	static func defaults() -> AAPSettings {
		return AAPSettings()
	}
}
