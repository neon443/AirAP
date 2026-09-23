//
//  MetadataChunkView.swift
//  AirAP
//
//  Created by neon443 on 31/08/2026.
//

import Foundation
import UIKit

class MetadataChunkView: UIStackView {
	var image: UIImageView
	var content: UILabel
	
	init(image: UIImage?) {
		self.content = UILabel()
		self.content.text = "._."
		self.content.font = UIFont.preferredFont(forTextStyle: .headline)
		self.content.layer.shadowColor = UIColor.background.cgColor
		self.content.layer.shadowOpacity = 0.5
		self.content.layer.shadowRadius = 3
		self.content.clipsToBounds = true
		self.content.layer.masksToBounds = true
		
		self.image = .init(image: image)
		self.image.contentMode = .scaleAspectFit
		
		super.init(frame: .zero)
		
		self.axis = .vertical
		self.alignment = alignment
		self.addArrangedSubview(self.image)
		self.addArrangedSubview(self.content)
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setContent(to newContent: String?, animated: Bool = true) {
		if animated {
			let animation: CATransition = .init()
			animation.duration = 0.3
			animation.type = .fade
			animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
			content.layer.add(animation, forKey: "changeTextTransition")
		}
		self.content.text = newContent
	}
}
