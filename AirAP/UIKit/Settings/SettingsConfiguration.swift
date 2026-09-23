//
//  SettingsConfiguration.swift
//  AirAP
//
//  Created by neon443 on 17/09/2026.
//

import Foundation
import UIKit

extension SettingsViewController {
	struct SettingsConfiguration {
		var category: Category
		var type: SettingType
		var itemIndex: Int
		var title: String
		var onChange: ((AirstreamManager, Any) -> Void)?
		var sliderConfig: SliderConfiguration?
		var segmentConfig: SegmentedControlConfiguration?
		
		init(category: Category, itemIndex: Int, type: SettingType, title: String) {
			self.category = category
			self.type = type
			self.itemIndex = itemIndex
			self.title = title
		}
		
		func currentValue(asManager: AirstreamManager) -> Any {
			switch category {
			case .server:
				if itemIndex == 0 {
					return asManager.settings.name
				} else {
					return asManager.settings.password ?? ""
				}
			case .audio:
				return asManager.settings.delay
			case .display:
				if itemIndex == 0 {
					return asManager.settings.showBg
				} else if itemIndex == 1 {
					return asManager.settings.bgOpacity
				} else if itemIndex == 2 {
					return asManager.settings.bgBlur
				} else {
					return asManager.settings.keepAwake
				}
			case .metadata:
				if itemIndex == 0 {
					return asManager.settings.showMetadata
				} else {
					return asManager.settings.showAudioQuality
				}
			case .stats:
				return false
			}
		}
	}
	
	enum SettingType: Int, RawRepresentable {
		case toggle
		case slider
		case textField
		case segment
		case stats
	}
	
	struct SliderConfiguration {
		var range: ClosedRange<Float>
		var step: Float
		
		var unit: String
		
		var defaultValue: Float
		var leading: String
		var trailing: String
		
		init(
			range: ClosedRange<Float>,
			step: Float,
			unit: String,
			defaultValue: Float,
			leading: String? = nil,
			trailing: String? = nil
		) {
			self.range = range
			self.step = step
			self.unit = unit
			self.defaultValue = defaultValue
			self.leading = leading ?? "\(Int(range.lowerBound))"
			self.trailing = trailing ?? "\(Int(range.upperBound))"
		}
	}
	struct SegmentedControlConfiguration {
		var numberOfSegments: Int
		var titleFor: ((Int) -> String)
		var titles: [String] {
			var result: [String] = []
			for i in 0..<numberOfSegments {
				result.append(titleFor(i))
			}
			return result
		}
		
		init(numberOfSegments: Int, titleFor: @escaping (Int) -> String) {
			self.numberOfSegments = numberOfSegments
			self.titleFor = titleFor
		}
	}
}

extension SettingsViewController.Category {
	func settingsConfigFor(item itemIndex: Int) -> SettingsViewController.SettingsConfiguration {
		guard itemIndex <= self.contains-1 else { fatalError("item out of raneg2") }
		
		let type = settingTypeFor(item: itemIndex)
		var config = SettingsViewController.SettingsConfiguration(category: self, itemIndex: itemIndex, type: type, title: "uninitialised")
		
		let title: String
		switch self {
		case .server:
			if itemIndex == 0 {
				title = "Name"
				config.onChange = { asManager, newValue in
					let newValue = newValue as! String
					asManager.settings.name = newValue
				}
			} else {
				title = "Password"
				config.onChange = { asManager, newValue in
					let newValue = newValue as! String
					asManager.settings.password = newValue
					asManager.airstream?.password = newValue
				}
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
		case .display:
			if itemIndex == 0 {
				title = "Theme background"
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
			} else if itemIndex == 2 {
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
			} else {
				title = "Keep screen awake"
				config.onChange = { asManager, newValue in
					let newValue = newValue as! Bool
					asManager.settings.keepAwake = newValue
					UIApplication.shared.isIdleTimerDisabled = newValue
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
			title = ""
			print("idk :)")
		}
		
		config.title = title
		
		return config
	}
}
