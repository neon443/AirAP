//
//  ToggleSettingsCell.swift
//  AirAP
//
//  Created by neon443 on 06/09/2026.
//

import Foundation
import UIKit

class ToggleSettingsCell: SettingsCell {
	var titleLabel: UILabel
	var toggle: UISwitch!
	
	var stack: UIStackView!
	
	override init(asManager: AirstreamManager, config: SettingsViewController.SettingsConfiguration) {
		self.titleLabel = UILabel()
		
		super.init(asManager: asManager, config: config)
		
		self.toggle = UISwitch(frame: .zero)
		self.stack = UIStackView(arrangedSubviews: [titleLabel, toggle])
		
		setup()
		
		refreshUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func toggleToggled() {
		self.config.onChange?(asManager, self.toggle.isOn)
		asManager.settings.saveSettings()
	}
	
	func setup() {
		toggle.addTarget(self, action: #selector(toggleToggled), for: .valueChanged)
		
		stack.axis = .horizontal
		stack.distribution = .equalSpacing
		
		self.contentView.addSubview(stack)
		stack.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
			stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
		])
	}
	
	override func refreshUI() {
		super.refreshUI()
		self.toggle.isOn = config.currentValue(asManager: asManager) as? Bool ?? false
		titleLabel.text = config.title
	}
}
