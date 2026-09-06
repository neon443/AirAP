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
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	enum Category: Int, CaseIterable {
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
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let category = Category(rawValue: indexPath.section) else { fatalError("invalid section \(indexPath.section)") }
		switch category {
		case .server:
			return ToggleSettingsCell(title: "a", state: false)
		case .audio:
			return ToggleSettingsCell(title: "a", state: false)
		case .background:
			return ToggleSettingsCell(title: "a", state: false)
		case .metadata:
			return ToggleSettingsCell(title: "a", state: false)
		}
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard let category = Category(rawValue: section) else { fatalError("invalid section \(section)") }
		switch category {
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
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return Category.allCases.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let category = Category(rawValue: section) else { fatalError("invalid section \(section)") }
		return category.contains
	}
}
