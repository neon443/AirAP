//
//  TextFieldSettingsCell.swift
//  AirAP
//
//  Created by neon443 on 06/09/2026.
//

import Foundation
import UIKit

class TextFieldSettingsCell: SettingsCell {
	var textField: UITextField
	
	override init(asManager: AirstreamManager, config: SettingsViewController.SettingsConfiguration) {
		self.textField = UITextField()
		
		super.init(asManager: asManager, config: config)
		
		setup()
		refreshUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func textChanged() {
		guard let text = self.textField.text else { return }
		self.config.onChange?(self.asManager, text)
		self.asManager.settings.saveSettings()
	}
	
	func setup() {
		textField.placeholder = "Server Name"
		textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
		
		self.contentView.addSubview(textField)
		self.textField.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			textField.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
			textField.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
		])
	}
	
	override func refreshUI() {
		self.textField.text = config.currentValue(asManager: asManager) as? String
		
	}
}
