//
//  SettingsConfiguration.swift
//  AirAP
//
//  Created by neon443 on 17/09/2026.
//

import Foundation

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
				return asManager.settings.name
			case .audio:
				return asManager.settings.delay
			case .background:
				if itemIndex == 0 {
					return asManager.settings.showBg
				} else if itemIndex == 1 {
					return asManager.settings.bgOpacity
				} else {
					return asManager.settings.bgBlur
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
