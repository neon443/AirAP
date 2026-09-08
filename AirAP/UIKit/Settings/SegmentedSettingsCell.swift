//
//  SegmentedSettingsCell.swift
//  AirAP
//
//  Created by neon443 on 08/09/2026.
//

import Foundation
import UIKit

class SegmentedSettingsCell: SettingsCell {
	var segmentedControl: UISegmentedControl
	
	var title: UILabel
//	var infoStack: UIStackView
	
	var stack: UIStackView
	
	override init(asManager: AirstreamManager, config: SettingsViewController.SettingsConfiguration) {
		self.segmentedControl = UISegmentedControl()
		
		self.title = UILabel()
//		self.infoStack = UIStackView(arrangedSubviews: [title, resetButton])
		
		self.stack = UIStackView(arrangedSubviews: [title, segmentedControl])
		
		super.init(asManager: asManager, config: config)
		setup()
		refreshUI()
	}
	
	@MainActor required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func segmentChanged() {
		self.config.onChange?(self.asManager, self.segmentedControl.selectedSegmentIndex)
		self.asManager.settings.saveSettings()
	}
	
	func setup() {
//		infoStack.axis = .horizontal
//		infoStack.distribution = .equalSpacing
		
		stack.axis = .vertical
		stack.spacing = 12
		
		segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
		
		contentView.addSubview(stack)
		stack.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
//			resetButton.heightAnchor.constraint(equalTo: title.heightAnchor, multiplier: 1.25),
			
			stack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
			stack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
			stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
			stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
		])
	}
	
	override func refreshUI() {
		super.refreshUI()
		
		guard let segmentConfig = config.segmentConfig else { fatalError("segment config niil") }
		
		title.text = config.title
		segmentedControl.removeAllSegments()
		
		for title in segmentConfig.titles {
			segmentedControl.insertSegment(
				withTitle: title,
				at: segmentedControl.numberOfSegments,
				animated: false
			)
		}
		segmentedControl.selectedSegmentIndex = (config.currentValue(asManager: asManager) as! AAPSettings.bgBlurStrengths).rawValue
	}
}
