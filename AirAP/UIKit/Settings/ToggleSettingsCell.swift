//
//  ToggleSettingsCell.swift
//  AirAP
//
//  Created by neon443 on 06/09/2026.
//

import Foundation
import UIKit

class ToggleSettingsCell: UITableViewCell {
	var state: Bool
	var title: String
	var toggle: UISwitch!
	var onChange: ((Bool) -> Void)?
	
	init(title: String, state: Bool) {
		self.state = state
		self.title = title
		
		super.init(style: .default, reuseIdentifier: nil)
		
		self.toggle = UISwitch(
			frame: .zero,
			primaryAction: UIAction(handler: { action in
				self.state = self.toggle.isOn
				self.onChange?(self.state)
			})
		)
		
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		self.contentView.addSubview(toggle)
		toggle.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			toggle.topAnchor.constraint(equalTo: contentView.topAnchor),
			toggle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			toggle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
}
