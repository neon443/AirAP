//
//  StatsSettingsCell.swift
//  AirAP
//
//  Created by neon443 on 17/09/2026.
//

import Foundation
import UIKit

class StatsSettingsCell: SettingsCell {
	var portLabel: UILabel
	
	var stack: UIStackView
	
	override init(asManager: AirstreamManager, config: SettingsViewController.SettingsConfiguration) {
		self.portLabel = UILabel()
		self.stack = UIStackView(arrangedSubviews: [portLabel])
		
		super.init(asManager: asManager, config: config)
		
		setup()
		refreshUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		contentView.addSubview(stack)
		stack.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
			stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
			stack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
			stack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
		])
	}
	
	override func refreshUI() {
		super.refreshUI()
		portLabel.text = "\(asManager.airstream!.port)"
	}
}
