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
	var bgBlur: AAPSettings.bgBlurStrengths
	var showMetadata: Bool
	var showAudioQuality: Bool
	var delay: Float
	
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
}

<<<<<<<< HEAD:AirAP/SwiftUI/Settings/AAPSettings.swift
@available(iOS 13, *)
class AAPSettingsModel: ObservableObject {
	@Published var name: String = "AirAP"
	@Published var showBg: Bool = true
	@Published var bgOpacity: CGFloat = 0.8
	@Published var bgBlur: CGFloat = 75
	@Published var showMetadata: Bool = true
	@Published var showAudioQuality: Bool = true
	@Published var delay: CGFloat = 0
========
class AAPSettingsModel {
	var name: String = "AirAP"
	var showBg: Bool = true
	var bgOpacity: Float = 0.8
	var bgBlur: AAPSettings.bgBlurStrengths = .systemUltraThinMaterial
	var showMetadata: Bool = true
	var showAudioQuality: Bool = true
	var delay: Float = 0
>>>>>>>> uikit:AirAP/AAPSettings.swift
	
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
