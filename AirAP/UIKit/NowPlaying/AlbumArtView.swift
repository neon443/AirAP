//
//  AlbumArtView.swift
//  AirAP
//
//  Created by neon443 on 31/08/2026.
//

import Foundation
import UIKit

class AlbumArtView: UIVisualEffectView {
	var asManager: AirstreamManager
	var imageView: UIImageView
	
	init(asManager: AirstreamManager) {
		self.asManager = asManager
		self.imageView = UIImageView()
		
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
		self.layer.cornerRadius = 24
		if #available(iOS 13, *) {
			self.layer.cornerCurve = .continuous
		}
		self.layer.masksToBounds = true
		imageView.contentMode = .scaleAspectFit
		imageView.layer.cornerRadius = 16
		imageView.layer.masksToBounds = true
		
		contentView.addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.widthAnchor.constraint(equalTo: self.heightAnchor),
			
			imageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
			imageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
		])
	}
	
	func refreshUI() {
		let animation: CATransition = .init()
		animation.duration = 0.3
		animation.type = .fade
		animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		imageView.layer.add(animation, forKey: "changeImageTransition")
		
		if let newImage = asManager.albumArt {
			self.imageView.image = newImage
			contentView.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
		} else {
			self.imageView.image = UIImage(named: "music.note")
			contentView.layoutMargins = .init(top: 128, left: 128, bottom: 128, right: 128)
		}
	}
}
