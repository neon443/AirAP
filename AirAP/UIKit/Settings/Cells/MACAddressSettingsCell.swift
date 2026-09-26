//
//  MACAddressSettingsCell.swift
//  AirAP
//
//  Created by neon443 on 25/09/2026.
//

import Foundation
import UIKit

class MACAddressSettingsCell: SettingsCell {
	var stack: UIStackView
	var title: UILabel
	var textFields: [UITextField]
	var textFieldStack: UIStackView
	
	override init(asManager: AirstreamManager, config: SettingsViewController.SettingsConfiguration) {
		self.title = UILabel()
		self.textFields = .init(repeating: UITextField(), count: 6)
		self.textFieldStack = UIStackView(arrangedSubviews: textFields)
		
		self.stack = UIStackView(arrangedSubviews: [title, textFieldStack])
		
		super.init(asManager: asManager, config: config)
		
		setup()
		refreshUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func textFieldChanged() {
		for textField in textFields {
			debugPrint(textField.text ?? "")
		}
	}
	
	func setup() {
		for textField in textFields {
			textField.borderStyle = .roundedRect
			textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
		}
		textFieldStack.axis = .horizontal
		
		stack.spacing = 2
		contentView.addSubview(stack)
		stack.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			stack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
			stack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
			stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
			stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
		])
	}
	
	override func refreshUI() {
		super.refreshUI()
		self.title.text = config.title
		
	}
}
