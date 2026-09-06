//
//  ToggleSettingsCell.swift
//  AirAP
//
//  Created by neon443 on 06/09/2026.
//

import Foundation
import UIKit

class ToggleSettingsCell: SettingsCell {
	var state: Bool
	
	var titleLabel: UILabel
	var toggle: UISwitch!
	
	var stack: UIStackView!
	
	override init(asManager: AirstreamManager, config: SettingsViewController.SettingsConfiguration) {
		self.state = false
		self.titleLabel = UILabel()
		
		super.init(asManager: asManager, config: config)
		
		self.toggle = UISwitch(
			frame: .zero,
			primaryAction: UIAction(handler: { action in
				self.state = self.toggle.isOn
				self.config.onChange?(asManager, self.state)
				asManager.settings.saveSettings()
			})
		)
		self.stack = UIStackView(arrangedSubviews: [titleLabel, toggle])
		
		setup()
		
		refreshUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		stack.axis = .horizontal
		stack.distribution = .equalSpacing
		
		self.contentView.addSubview(stack)
		stack.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			stack.topAnchor.constraint(equalTo: contentView.topAnchor),
			stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
	
	override func refreshUI() {
		super.refreshUI()
		titleLabel.text = config.title
		toggle.isOn = state
	}
}
