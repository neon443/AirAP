//
//  SettingsCategory.swift
//  AirAP
//
//  Created by neon443 on 17/09/2026.
//

import Foundation

extension SettingsViewController {
	enum Category: Int, CaseIterable, CustomStringConvertible {
		case server
		case audio
		case background
		case metadata
		case stats
		
		var contains: Int {
			switch self {
			case .server:
				return 1
			case .audio:
				return 1
			case .background:
				return 3
			case .metadata:
				return 2
			case .stats:
				return 1
			}
		}
		
		var description: String {
			switch self {
			case .server:
				return "Server"
			case .audio:
				return "Audio"
			case .background:
				return "Background"
			case .metadata:
				return "Metadata"
			case .stats:
				return "Stats"
			}
		}
		
		var footnote: String? {
			switch self {
			case .server, .audio:
				return "Restart server to apply changes"
			case .background, .metadata, .stats:
				return nil
			}
		}
		
		private func settingTypeFor(item itemIndex: Int) -> SettingType {
			guard itemIndex <= self.contains-1 else { fatalError("item out of raneg") }
			switch self {
			case .server:
				return .textField
			case .audio:
				return .slider
			case .background:
				if itemIndex == 0 {
					return .toggle
				} else if itemIndex == 1 {
					return .slider
				} else {
					return .segment
				}
			case .metadata:
				return .toggle
			case .stats:
				return .stats
			}
		}
		
		func settingsConfigFor(item itemIndex: Int) -> SettingsConfiguration {
			guard itemIndex <= self.contains-1 else { fatalError("item out of raneg2") }
			
			let type = settingTypeFor(item: itemIndex)
			var config = SettingsConfiguration(category: self, itemIndex: itemIndex, type: type, title: "uninitialised")
			
			let title: String
			switch self {
			case .server:
				title = ""
				config.onChange = { asManager, newValue in
					let newValue = newValue as! String
					asManager.settings.name = newValue
				}
			case .audio:
				title = "Delay"
				config.sliderConfig = .init(
					range: -2...2,
					step: 0.25,
					unit: "s",
					defaultValue: 0
				)
				config.onChange = { asManager, newValue in
					let newValue = newValue as! Float
					asManager.settings.delay = newValue
				}
			case .background:
				if itemIndex == 0 {
					title = "Show album art"
					config.onChange = { asManager, newValue in
						let newValue = newValue as! Bool
						asManager.settings.showBg = newValue
					}
				} else if itemIndex == 1 {
					title = "Opacity"
					config.sliderConfig = .init(
						range: 0...100,
						step: 5,
						unit: "%",
						defaultValue: 80
					)
					config.onChange = { asManager, newValue in
						let newValue = newValue as! Float
						asManager.settings.bgOpacity = newValue
					}
				} else {
					title = "Blur"
					config.segmentConfig = .init(
						numberOfSegments: 4,
						titleFor: { index in
							AAPSettings.bgBlurStrengths(rawValue: index)!.description
						}
					)
					config.onChange = { asManager, newValue in
						let newValue = newValue as! Int
						asManager.settings.bgBlur = AAPSettings.bgBlurStrengths(rawValue: newValue)!
					}
				}
			case .metadata:
				if itemIndex == 0 {
					title = "Show metadata"
					config.onChange = { asManager, newValue in
						let newValue = newValue as! Bool
						asManager.settings.showMetadata = newValue
					}
				} else {
					title = "Show audio quality information"
					config.onChange = { asManager, newValue in
						let newValue = newValue as! Bool
						asManager.settings.showAudioQuality = newValue
					}
				}
			case .stats:
				title = "nil"
				print("idk :)")
			}
			
			config.title = title
			
			return config
		}
	}
}
