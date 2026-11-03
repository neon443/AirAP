//
//  ServerStateButton.swift
//  AirAP
//
//  Created by neon443 on 07/09/2026.
//

import Foundation
import UIKit

class ServerStateButton: UIVisualEffectView {
	var image: UIImageView
	var label: UILabel
	var stack: UIStackView
	
	init() {
		self.image = UIImageView()
		self.label = UILabel()
		self.stack = UIStackView(arrangedSubviews: [image, UIView(), label])
		
		var effect: UIVisualEffect
		effect = UIBlurEffect(style: .systemUltraThinMaterialSafe)
#if compiler(>=6.2)
		if #available(iOS 19, *) {
			let glassEffect = UIGlassEffect(style: .clear)
			glassEffect.isInteractive = true
			effect = glassEffect
		}
#endif
		super.init(effect: effect)

		setup()
		refreshUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		self.label.font = .preferredFont(forTextStyle: .footnote)
		
		self.isUserInteractionEnabled = true
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
		
		image.contentMode = .scaleAspectFit
		
		stack.axis = .horizontal
		stack.spacing = 0
		stack.layoutMargins = UIEdgeInsets(top: 4, left: 32, bottom: 4, right: 4)
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
		let isRunning = AirAP.asManager.airstream!.running
		
		self.image.image = UIImage(named: isRunning ? "square.fill" : "airplay.audio")
		self.label.text = isRunning ? "Stop" : "Start"
		stack.layoutMargins.left = isRunning ? 5 : 3
		setTint(to: (isRunning ? UIColor.systemRed : UIColor.systemGreen))
	}
	
	func setTint(to color: UIColor) {
		self.backgroundColor = color.withAlphaComponent(0.8)
	}
	
	@objc func tapped() {
		AirAP.asManager.startStop()
		self.refreshUI()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.layer.cornerRadius = self.bounds.height/2
		if #available(iOS 13, *) {
			self.layer.cornerCurve = .continuous
		}
		self.layer.masksToBounds = true
	}
}
