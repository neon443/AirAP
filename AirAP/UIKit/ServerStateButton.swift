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
	var button: UIButton
	
	init(asManager: AirstreamManager) {
		self.asManager = asManager
		self.button = UIButton(type: .system)
		
		var effect: UIVisualEffect
		if #available(iOS 19, *) {
			let glassEffect = UIGlassEffect()
			glassEffect.isInteractive = true
			effect = glassEffect
		} else {
			effect = UIBlurEffect(style: .systemThinMaterial)
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
		
		button.isUserInteractionEnabled = false
		button.imageView?.contentMode = .scaleAspectFit
		button.tintColor = .foreground
		
		self.contentView.addSubview(button)
		button.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			contentView.topAnchor.constraint(equalTo: button.topAnchor, constant: -8),
			contentView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: -12),
			contentView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 12),
			contentView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 8)
		])
		self.layer.cornerRadius = button.bounds.height/2
		self.layer.masksToBounds = true
	}
	
	func refreshUI() {
		let isRunning = asManager.running
		
		button.setImage(UIImage(systemName: isRunning ? "square.fill" : "airplay.audio"), for: .normal)
		button.setTitle(isRunning ? "Stop" : "Start", for: .normal)
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
