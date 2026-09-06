//
//  SliderSettingsCell.swift
//  AirAP
//
//  Created by neon443 on 06/09/2026.
//

import Foundation
import UIKit

class SliderSettingsCell: SettingsCell {
	var slider: UISlider
	var minLabel: UILabel
	var maxLabel: UILabel
	var sliderStack: UIStackView
	
	var titleLabel: UILabel
	var valueLabel: UILabel
	var resetButton: UIButton
	var infoStack: UIStackView
	
	var stack: UIStackView
	
	override init(asManager: AirstreamManager, config: SettingsViewController.SettingsConfiguration) {
		titleLabel = UILabel()
		valueLabel = UILabel()
		resetButton = UIButton(type: .custom)
		infoStack = UIStackView(arrangedSubviews: [titleLabel, valueLabel, resetButton])
		
		minLabel = UILabel()
		slider = UISlider()
		maxLabel = UILabel()
		sliderStack = UIStackView(arrangedSubviews: [minLabel, slider, maxLabel])
		
		stack = UIStackView(arrangedSubviews: [infoStack, sliderStack])
		
		super.init(asManager: asManager, config: config)
		setup()
		refreshUI()
	}
	
	@MainActor required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		guard let sliderConfig = self.config.sliderConfig else { fatalError("no slider config bru") }
		
		infoStack.axis = .horizontal
		infoStack.distribution = .equalSpacing
		sliderStack.axis = .horizontal
		sliderStack.spacing = 4
		stack.axis = .vertical
		stack.spacing = 4
		
		slider.minimumValue = sliderConfig.range.lowerBound
		slider.maximumValue = sliderConfig.range.upperBound
		
		slider.addAction(UIAction(handler: { action in
			let value = round(self.slider.value / sliderConfig.step) * sliderConfig.step
			self.slider.setValue(value, animated: false)
			self.config.onChange?(self.asManager, value)
			self.valueLabel.text = "\(self.slider.value)" + sliderConfig.unit
			self.asManager.settings.saveSettings()
		}), for: .valueChanged)
		
		contentView.addSubview(stack)
		stack.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
			stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
		])
	}
	
	override func refreshUI() {
		guard let sliderConfig = self.config.sliderConfig else { fatalError("no slider config bru") }
		
		self.slider.value = config.currentValue(asManager: asManager) as? Float ?? 0
		self.minLabel.text = "\(sliderConfig.leading)" + sliderConfig.unit
		self.maxLabel.text = "\(sliderConfig.trailing)" + sliderConfig.unit
		self.valueLabel.text = "\(slider.value)" + sliderConfig.unit
	}
}
