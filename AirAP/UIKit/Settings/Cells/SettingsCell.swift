//
//  SettingsCell.swift
//  AirAP
//
//  Created by neon443 on 06/09/2026.
//

import Foundation
import UIKit

class SettingsCell: UITableViewCell {
	var config: SettingsViewController.SettingsConfiguration
	
	init(config: SettingsViewController.SettingsConfiguration) {
		self.config = config
		super.init(style: .default, reuseIdentifier: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func refreshUI() {
		
	}
}
