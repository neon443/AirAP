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
		
		if #available(iOS 19, *) {
			let glassEffect = UIGlassEffect(style: .clear)
			glassEffect.isInteractive = true
			super.init(effect: glassEffect)
		} else {
			super.init(effect: UIBlurEffect(style: .systemUltraThinMaterialSafe))
			self.layer.masksToBounds = true
		}
		
		setup()
		
		refreshUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		self.layer.cornerRadius = 24
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
		let newImage = asManager.albumArt
		
		if let newImage {
			self.imageView.image = newImage
			contentView.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
		} else {
			self.imageView.image = UIImage(named: "music.note")
			contentView.layoutMargins = .init(top: 128, left: 128, bottom: 128, right: 128)
		}
	}
}
