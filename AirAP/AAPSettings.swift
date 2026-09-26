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
	var password: String?
	var address: [UInt8]
	var delay: Float
	var showBg: Bool
	var bgOpacity: Float
	var bgBlur: AAPSettings.bgBlurStrengths
	var keepAwake: Bool
	var showMetadata: Bool
	var showAudioQuality: Bool
	
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
		password: String? = nil,
		address: [UInt8],
		delay: Float,
		showBg: Bool,
		bgOpacity: Float,
		bgBlur: AAPSettings.bgBlurStrengths,
		keepAwake: Bool,
		showMetadata: Bool,
		showAudioQuality: Bool
	) {
		self.name = name
		self.password = password
		self.address = address
		self.delay = delay
		self.showBg = showBg
		self.bgOpacity = bgOpacity
		self.bgBlur = bgBlur
		self.keepAwake = keepAwake
		self.showMetadata = showMetadata
		self.showAudioQuality = showAudioQuality
	}
	
	init(clean: Bool = false) {
		let decoder = JSONDecoder()
		
		guard let data = AAPSettings.userDefaults.data(forKey: "settings"),
			  let decoded = try? decoder.decode(AAPSettings.self, from: data),
			  clean == false else {
			self.name = "AirAP"
			self.password = nil
			self.address = [0x48, 0x5d, 0x60, 0x7c, 0xee, 0x22]
			self.delay = 0
			self.showBg = true
			self.bgOpacity = 0.8
			self.bgBlur = .systemUltraThinMaterial
			self.keepAwake = false
			self.showMetadata = true
			self.showAudioQuality = false
			return
		}
		
		self.name = decoded.name
		self.password = decoded.password
		self.address = decoded.address
		self.delay = decoded.delay
		self.showBg = decoded.showBg
		self.bgOpacity = decoded.bgOpacity
		self.bgBlur = decoded.bgBlur
		self.keepAwake = decoded.keepAwake
		self.showMetadata = decoded.showMetadata
		self.showAudioQuality = decoded.showAudioQuality
		
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
