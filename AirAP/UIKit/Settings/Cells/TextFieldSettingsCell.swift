//
//  TextFieldSettingsCell.swift
//  AirAP
//
//  Created by neon443 on 06/09/2026.
//

import Foundation
import UIKit

class TextFieldSettingsCell: SettingsCell, UITextFieldDelegate {
	var stack: UIStackView
	var labelStack: UIStackView
	var pencilImage: UIImageView
	var label: UILabel
	var textField: UITextField
	
//	convenience init(asManager: AirstreamManager, config: SettingsViewController.SettingsConfiguration, secure: Bool) {
//		self.init(asManager: asManager, config: config)
//		self.textField.isSecureTextEntry
//		self.textField.
//	}
	
	override init(asManager: AirstreamManager, config: SettingsViewController.SettingsConfiguration) {
		self.label = UILabel()
		self.pencilImage = UIImageView(image: UIImage(named: "pencil"))
		self.labelStack = UIStackView(arrangedSubviews: [label, pencilImage])
		self.textField = UITextField()
		self.stack = UIStackView(arrangedSubviews: [labelStack, textField])
		
		super.init(asManager: asManager, config: config)
		
		setup()
		refreshUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		labelStack.distribution = .equalSpacing
		
		stack.axis = .vertical
		stack.spacing = 2
		
		textField.delegate = self
		textField.returnKeyType = .done
		textField.placeholder = "Enter a \(config.title.lowercased())"
		textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
		
		self.contentView.addSubview(stack)
		self.stack.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
			stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
			stack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
			stack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
		])
	}
	
	override func refreshUI() {
		self.textField.text = config.currentValue(asManager: asManager) as? String
		label.text = config.title
	}
	
	@objc func textChanged() {
		guard let text = self.textField.text else { return }
		self.config.onChange?(self.asManager, text)
		self.asManager.settings.saveSettings()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
