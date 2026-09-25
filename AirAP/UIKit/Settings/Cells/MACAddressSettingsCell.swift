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
	
	override init(asManager: AirstreamManager, config: SettingsViewController.SettingsConfiguration) {
		self.stack = UIStackView(frame: .zero)
		self.title = UILabel()
		self.textFields = .init(repeating: UITextField(), count: 6)
		
		super.init(asManager: asManager, config: config)
		
		setup()
		refreshUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	
	func setup() {
		for textField in textFields {
			textField.borderStyle = .roundedRect
//			textField.addTarget(self, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
		}
	}
	
	override func refreshUI() {
		super.refreshUI()
		self.title.text = config.title
		
	}
}
