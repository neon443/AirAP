//
//  AAPSettings.swift
//  AirAP
//
//  Created by neon443 on 25/05/2025.
//

import Foundation
import UIKit

struct AAPSettings: Codable {
	var name: String							= "AirAP"
	var password: String?						= nil
	var showBg: Bool							= true
	var bgOpacity: Float						= 0.8
	var bgBlur: AAPSettings.bgBlurStrengths		= .systemUltraThinMaterial
	var showMetadata: Bool						= true
	var showAudioQuality: Bool					= true
	var delay: Float							= 0
	
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
	
	init(clean: Bool = false) {
		guard let data = AAPSettings.userDefaults.data(forKey: "settings") else { return }
		
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
		if let encoded = try? encoder.encode(self) {
			AAPSettings.userDefaults.set(encoded, forKey: "settings")
		}
	}
	
	static func defaults() -> AAPSettings {
		AAPSettings(clean: true)
	}
}
