//
//  ServerStateButton.swift
//  AirAP
//
//  Created by neon443 on 07/09/2026.
//

import Foundation
import UIKit

class ServerStateButton: UIVisualEffectView {
	var asManager: AirstreamManager
	
	var image: UIImageView
	var label: UILabel
	var stack: UIStackView
	
	init(asManager: AirstreamManager) {
		self.asManager = asManager
		self.image = UIImageView()
		self.label = UILabel()
		self.stack = UIStackView(arrangedSubviews: [image, label])
		
		var effect: UIVisualEffect
		if #available(iOS 19, *) {
			let glassEffect = UIGlassEffect()
			glassEffect.isInteractive = true
			effect = glassEffect
		} else {
			effect = UIBlurEffect(style: .systemThinMaterialSafe)
		}
		
		super.init(effect: effect)

		setup()
		refreshUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		self.isUserInteractionEnabled = true
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
		
		image.contentMode = .scaleAspectFit
		
		stack.axis = .horizontal
		stack.spacing = 4
		stack.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		stack.isLayoutMarginsRelativeArrangement = true
		
		self.contentView.addSubview(stack)
		stack.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			contentView.topAnchor.constraint(equalTo: stack.topAnchor),
			contentView.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
			contentView.bottomAnchor.constraint(equalTo: stack.bottomAnchor)
		])
		self.layer.cornerRadius = stack.bounds.height/2
		self.layer.masksToBounds = true
	}
	
	func refreshUI() {
		let isRunning = asManager.running
		
		self.image.image = UIImage(named: isRunning ? "square.fill" : "airplay.audio")
		self.label.text = isRunning ? "Stop" : "Start"
		stack.layoutMargins.left = isRunning ? 12 : 8
		setTint(to: (isRunning ? UIColor.systemRed : UIColor.systemGreen))
	}
	
	func setTint(to color: UIColor) {
		if #available(iOS 19, *),
		   let effect = self.effect as? UIGlassEffect {
			effect.tintColor = color
		} else {
			self.backgroundColor = color.withAlphaComponent(0.5)
		}
	}
	
	@objc func tapped() {
		self.asManager.startStop()
		self.refreshUI()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.layer.cornerRadius = self.bounds.height/2
		self.layer.masksToBounds = true
	}
}
