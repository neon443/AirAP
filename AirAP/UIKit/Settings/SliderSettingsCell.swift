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
	var trailingStack: UIStackView
	var infoStack: UIStackView
	
	var stack: UIStackView
	
	override init(asManager: AirstreamManager, config: SettingsViewController.SettingsConfiguration) {
		titleLabel = UILabel()
		valueLabel = UILabel()
		resetButton = UIButton(type: .custom)
		trailingStack = UIStackView(arrangedSubviews: [valueLabel, resetButton])
		infoStack = UIStackView(arrangedSubviews: [titleLabel, trailingStack])
		
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
		
		titleLabel.textAlignment = .left
		valueLabel.font = valueLabel.font.withWeight(.bold)
		valueLabel.textAlignment = .center
		
		resetButton.setImage(UIImage(systemName: "arrow.uturn.backward"), for: .normal)
		resetButton.addAction(UIAction(handler: { action in
			guard let sliderConfig = self.config.sliderConfig else { fatalError("no slider config bru") }
			self.slider.setValue(sliderConfig.defaultValue, animated: true)
			self.sliderSet()
		}), for: .touchUpInside)
		trailingStack.axis = .horizontal
		trailingStack.spacing = 8
//		infoStack.distribution = .equalSpacing
		infoStack.axis = .horizontal
		infoStack.distribution = .equalSpacing
		
		maxLabel.font = .preferredFont(forTextStyle: .caption1)
		minLabel.font = .preferredFont(forTextStyle: .caption1)
		maxLabel.textColor = .systemGray
		minLabel.textColor = .systemGray
		maxLabel.textAlignment = .center
		minLabel.textAlignment = .left
		
		sliderStack.axis = .horizontal
		sliderStack.spacing = 4
		stack.axis = .vertical
		
		slider.minimumValue = sliderConfig.range.lowerBound
		slider.maximumValue = sliderConfig.range.upperBound
		
		slider.addAction(UIAction(handler: { action in
			self.sliderSet()
		}), for: .valueChanged)
		
		stack.spacing = 2
		contentView.addSubview(stack)
		stack.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			minLabel.widthAnchor.constraint(equalTo: maxLabel.widthAnchor),
			
			stack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
			stack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
			stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
			stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
		])
	}
	
	override func refreshUI() {
		guard let sliderConfig = self.config.sliderConfig else { fatalError("no slider config bru") }
		
		self.slider.value = config.currentValue(asManager: asManager) as? Float ?? 0
		sliderSet()
		self.minLabel.text = "\(sliderConfig.leading)" + sliderConfig.unit
		self.maxLabel.text = "\(sliderConfig.trailing)" + sliderConfig.unit
		self.titleLabel.text = config.title
	}
	
	func sliderSet() {
		guard let sliderConfig = self.config.sliderConfig else { fatalError("no slider config bru") }
		
		let value = round(self.slider.value / sliderConfig.step) * sliderConfig.step
		if config.currentValue(asManager: asManager) as! Float != value {
			UIImpactFeedbackGenerator(style: .light).impactOccurred()
		}
		
		self.slider.setValue(value, animated: false)
		self.setValueLabel(to: value)
		UIView.transition(with: trailingStack, duration: 0.15, options: .transitionCrossDissolve) {
			self.resetButton.isEnabled = value != sliderConfig.defaultValue
			self.resetButton.layoutIfNeeded()
		}
		
		self.config.onChange?(self.asManager, value)
		self.asManager.settings.saveSettings()
	}
	
	func setValueLabel(to value: Float) {
		guard let sliderConfig = self.config.sliderConfig else { fatalError("no slider config bru") }
		let string: String = slider.value.rounded() == value ? "\(Int(value))" : "\(value)"
		UIView.transition(with: trailingStack, duration: 0.15, options: .transitionCrossDissolve) {
			self.valueLabel.text = string + sliderConfig.unit
			self.valueLabel.layoutIfNeeded()
		}
	}
}
