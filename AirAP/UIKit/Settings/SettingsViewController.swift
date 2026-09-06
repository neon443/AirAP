//
//  SettingsViewController.swift
//  AirAP
//
//  Created by neon443 on 05/09/2026.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
	var asManager: AirstreamManager
	
	init(asManager: AirstreamManager) {
		self.asManager = asManager
		super.init(style: .insetGrouped)
		self.tableView.allowsSelection = false
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	enum Category: Int, CaseIterable, CustomStringConvertible {
		case server
		case audio
		case background
		case metadata
		
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
			}
		}
		
		var footnote: String? {
			switch self {
			case .server, .audio:
				return "Restart server to apply changes"
			case .background, .metadata:
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
				} else {
					return .slider
				}
			case .metadata:
				return .toggle
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
					config.sliderConfig = .init(
						range: 0...100,
						step: 5,
						unit: "px",
						defaultValue: 75
					)
					config.onChange = { asManager, newValue in
						let newValue = newValue as! Float
						asManager.settings.bgBlur = newValue
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
			}
			
			config.title = title
			
			return config
		}
	}
	struct SettingsConfiguration {
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
			}
		}
		var category: Category
		var type: SettingType
		var itemIndex: Int
		var title: String
		var onChange: ((AirstreamManager, Any) -> Void)?
		var sliderConfig: SliderConfiguration?
		
		init(category: Category, itemIndex: Int, type: SettingType, title: String) {
			self.category = category
			self.type = type
			self.itemIndex = itemIndex
			self.title = title
		}
	}
	
	enum SettingType: Int, RawRepresentable {
		case toggle
		case slider
		case textField
	}
	
	struct SliderConfiguration {
		var range: ClosedRange<Float>
		var step: Float
		
		var unit: String
		
		var defaultValue: Float
		var leading: Float
		var trailing: Float
		
		init(
			range: ClosedRange<Float>,
			step: Float,
			unit: String,
			defaultValue: Float,
			leading: Float? = nil,
			trailing: Float? = nil
		) {
			self.range = range
			self.step = step
			self.unit = unit
			self.defaultValue = defaultValue
			self.leading = leading ?? range.lowerBound
			self.trailing = trailing ?? range.upperBound
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let category = Category(rawValue: indexPath.section) else { fatalError("invalid section \(indexPath.section)") }
		
		let cell: SettingsCell
	
		let config = category.settingsConfigFor(item: indexPath.row)
		switch config.type {
		case .toggle:
			cell = ToggleSettingsCell(asManager: asManager, config: config)
		case .slider:
			cell = SliderSettingsCell(asManager: asManager, config: config)
		case .textField:
			cell = TextFieldSettingsCell(asManager: asManager, config: config)
		}
		return cell
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard let category = Category(rawValue: section) else { fatalError("invalid section \(section)") }
		return category.description
	}
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		guard let category = Category(rawValue: section) else { fatalError("invalid section \(section)") }
		return category.footnote
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return Category.allCases.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let category = Category(rawValue: section) else { fatalError("invalid section \(section)") }
		return category.contains
	}
}
