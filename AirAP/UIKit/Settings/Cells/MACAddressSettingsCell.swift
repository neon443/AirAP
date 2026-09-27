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
	var resetButton: UIButton
	var titleStack: UIStackView
	
	var textFields: [UITextField]
	var textFieldStack: UIStackView
	
	override init(asManager: AirstreamManager, config: SettingsViewController.SettingsConfiguration) {
		self.title = UILabel()
		self.resetButton = UIButton(type: .custom)
		self.titleStack = UIStackView(arrangedSubviews: [title, resetButton])
		
		self.textFields = []
		for _ in 0..<6 {
			self.textFields.append(UITextField())
		}
		self.textFieldStack = UIStackView(frame: .zero)
		
		self.stack = UIStackView(arrangedSubviews: [titleStack, textFieldStack])
		
		super.init(asManager: asManager, config: config)
		
		setup()
		refreshUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func textFieldChanged() {
		for textField in textFields {
			guard var text = textField.text else { continue }
			if text.isEmpty {
				text = "00"
			} else if text.count == 1 {
				text = "0" + text
			} else if text.count > 2 {
				text = String(text.dropLast(text.count - 2))
			}
			text = text.uppercased()
			text = text.map { HexadecimalDigit.validCharacters.contains($0) ? String($0) : "0" }.joined()
			textField.text = text
		}
		let newAddress: [UInt8] = textFields.map { UInt8(hex: $0.text!) ?? 0 }
		config.onChange?(asManager, newAddress)
		asManager.settings.saveSettings()
		refreshUI()
	}
	
	@objc func resetTapped() {
		config.onChange?(asManager, AAPSettings.defaults().address)
		asManager.settings.saveSettings()
		refreshUI()
	}
	
	func setup() {
		resetButton.setImage(UIImage(named: "arrow.uturn.backward"), for: .normal)
		resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
		titleStack.axis = .horizontal
		titleStack.distribution = .equalSpacing
		
		for textField in textFields {
			let index = self.textFields.firstIndex(of: textField)!
			textField.borderStyle = .roundedRect
			if #available(iOS 13, *) {
				textField.font = .monospacedSystemFont(ofSize: textField.font!.pointSize, weight: .regular)
			}
			textField.placeholder = AAPSettings.defaults().address[index].hex()
			textField.textAlignment = .center
			textField.addTarget(self, action: #selector(textFieldChanged), for: .editingDidEnd)
			textFieldStack.addArrangedSubview(textField)
			if index != 5 {
				let colon = UILabel()
				colon.text = " : "
				textFieldStack.addArrangedSubview(colon)
			}
		}
		textFieldStack.axis = .horizontal
		textFieldStack.distribution = .fillProportionally
		
		stack.axis = .vertical
		stack.spacing = 4
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
		let currentValue = config.currentValue(asManager: asManager) as! [UInt8]
		self.resetButton.isEnabled = currentValue != AAPSettings.defaults().address
		for i in currentValue.indices {
			textFields[i].text = currentValue[i].hex()
		}
	}
}
