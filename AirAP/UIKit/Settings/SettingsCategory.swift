//
//  SettingsCategory.swift
//  AirAP
//
//  Created by neon443 on 17/09/2026.
//

import Foundation
import UIKit

extension SettingsViewController {
	enum Category: Int, CaseIterable, CustomStringConvertible {
		case server
		case audio
		case display
		case metadata
		case stats
		
		var contains: Int {
			switch self {
			case .server:
				return 3
			case .audio:
				return 1
			case .display:
				return 4
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
			case .display:
				return "Display"
			case .metadata:
				return "Metadata"
			case .stats:
				return "Stats"
			}
		}
		
		var footnote: String? {
			switch self {
			case .server:
				return "Restart server to apply changes"
			case .audio:
				return "Restart server to apply changes"
			case .display, .metadata, .stats:
				return nil
			}
		}
		
		func settingTypeFor(item itemIndex: Int) -> SettingType {
			guard itemIndex <= self.contains-1 else { fatalError("item out of raneg") }
			switch self {
			case .server:
				if itemIndex == 0 {
					return .textField
				} else if itemIndex == 1 {
					return .textField
				} else {
					return .macAddress
				}
			case .audio:
				return .slider
			case .display:
				if itemIndex == 0 {
					return .toggle
				} else if itemIndex == 1 {
					return .slider
				} else if itemIndex == 2 {
					return .segment
				} else {
					return .toggle
				}
			case .metadata:
				return .toggle
			case .stats:
				return .stats
			}
		}
	}
}
