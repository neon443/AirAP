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
		var onChange: ((Any) -> Void)?
		var sliderConfig: SliderConfiguration?
		var segmentConfig: SegmentedControlConfiguration?
		
		init(category: Category, itemIndex: Int, type: SettingType, title: String) {
			self.category = category
			self.type = type
			self.itemIndex = itemIndex
			self.title = title
		}
		
		func currentValue() -> Any {
			switch category {
			case .server:
				if itemIndex == 0 {
					return AAPSettings.shared.name
				} else if itemIndex == 1 {
					return AAPSettings.shared.password ?? ""
				} else {
					return AAPSettings.shared.address
				}
			case .audio:
				return AAPSettings.shared.delay
			case .display:
				if itemIndex == 0 {
					return AAPSettings.shared.showBg
				} else if itemIndex == 1 {
					return AAPSettings.shared.bgOpacity
				} else if itemIndex == 2 {
					return AAPSettings.shared.bgBlur
				} else {
					return AAPSettings.shared.keepAwake
				}
//			case .persistence:
//				if itemIndex == 0 {
//					return AAPSettings.shared.keepAlive
//				} else {
//					return AAPSettings.shared.persistenceType
//				}
			case .metadata:
				if itemIndex == 0 {
					return AAPSettings.shared.showMetadata
				} else {
					return AAPSettings.shared.showAudioQuality
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
		case macAddress
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
		var rawValue: ((Any) -> Int)
		
		init(numberOfSegments: Int, titleFor: @escaping (Int) -> String, rawValueGetter: @escaping (Any) -> Int) {
			self.numberOfSegments = numberOfSegments
			self.titleFor = titleFor
			self.rawValue = rawValueGetter
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
				config.onChange = { newValue in
					let newValue = newValue as! String
					AAPSettings.shared.name = newValue
				}
			} else if itemIndex == 1 {
				title = "Password"
				config.onChange = { newValue in
					let newValue = newValue as! String
					AAPSettings.shared.password = newValue
				}
			} else {
				title = "MAC Address"
				config.onChange = { newValue in
					let newValue = newValue as! [UInt8]
					AAPSettings.shared.address = newValue
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
			config.onChange = { newValue in
				let newValue = newValue as! Float
				AAPSettings.shared.delay = newValue
			}
		case .display:
			if itemIndex == 0 {
				title = "Theme background"
				config.onChange = { newValue in
					let newValue = newValue as! Bool
					AAPSettings.shared.showBg = newValue
				}
			} else if itemIndex == 1 {
				title = "Opacity"
				config.sliderConfig = .init(
					range: 0...100,
					step: 5,
					unit: "%",
					defaultValue: 80
				)
				config.onChange = { newValue in
					let newValue = newValue as! Float
					AAPSettings.shared.bgOpacity = newValue
				}
			} else if itemIndex == 2 {
				title = "Blur"
				config.segmentConfig = .init(
					numberOfSegments: 4,
					titleFor: { AAPSettings.bgBlurStrengths(rawValue: $0)!.description },
					rawValueGetter: { ($0 as! AAPSettings.bgBlurStrengths).rawValue }
				)
				config.onChange = { newValue in
					let newValue = newValue as! Int
					AAPSettings.shared.bgBlur = AAPSettings.bgBlurStrengths(rawValue: newValue)!
				}
			} else {
				title = "Keep screen awake"
				config.onChange = { newValue in
					let newValue = newValue as! Bool
					AAPSettings.shared.keepAwake = newValue
					UIApplication.shared.isIdleTimerDisabled = newValue
				}
			}
//		case .persistence:
//			if itemIndex == 0 {
//				title = "Keep alive in background"
//				config.onChange = { newValue in
//					let newValue = newValue as! Bool
//					AAPSettings.shared.keepAlive = newValue
//					
//					if newValue == true &&
//						AAPSettings.shared.persistenceType == .location &&
//						!Backgrounder.shared.checkLocPerms() {
//						Backgrounder.shared.locationManager.requestAlwaysAuthorization()
//					}
//					Backgrounder.shared.start()
//				}
//			} else {
//				title = "Method"
//				config.segmentConfig = .init(
//					numberOfSegments: 2,
//					titleFor: { AAPSettings.persistenceType(rawValue: $0)!.description },
//					rawValueGetter: { ($0 as! AAPSettings.persistenceType).rawValue }
//				)
//				config.onChange = { newValue in
//					let newValue = newValue as! Int
//					AAPSettings.shared.persistenceType = AAPSettings.persistenceType(rawValue: newValue)!
//					
//					if AAPSettings.persistenceType(rawValue: newValue)! == .location &&
//						!Backgrounder.shared.checkLocPerms() {
//						Backgrounder.shared.locationManager.requestAlwaysAuthorization()
//					}
//				}
//			}
		case .metadata:
			if itemIndex == 0 {
				title = "Show metadata"
				config.onChange = { newValue in
					let newValue = newValue as! Bool
					AAPSettings.shared.showMetadata = newValue
				}
			} else {
				title = "Show audio quality information"
				config.onChange = { newValue in
					let newValue = newValue as! Bool
					AAPSettings.shared.showAudioQuality = newValue
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
