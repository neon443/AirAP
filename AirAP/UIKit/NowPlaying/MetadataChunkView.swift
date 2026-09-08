//
//  MetadataChunkView.swift
//  AirAP
//
//  Created by neon443 on 31/08/2026.
//

import Foundation
import UIKit

class MetadataChunkView: UIStackView {
	var title: UILabel
	var content: UILabel
	
	init(
		title: String,
		content: String? = nil,
		alignment: UIStackView.Alignment = .leading
	) {
		self.title = UILabel()
		self.title.text = title
		self.title.font = UIFont.preferredFont(forTextStyle: .subheadline, andWeight: .light)
		self.title.layer.shadowColor = UIColor(named: "background")?.cgColor
		self.title.layer.shadowOpacity = 0.5
		self.title.layer.shadowRadius = 3
		self.title.clipsToBounds = true
		self.title.layer.masksToBounds = true
		
		self.content = UILabel()
		self.content.text = title
		self.content.font = UIFont.preferredFont(forTextStyle: .title3)
		self.content.layer.shadowColor = UIColor(named: "background")?.cgColor
		self.content.layer.shadowOpacity = 0.5
		self.content.layer.shadowRadius = 3
		self.content.clipsToBounds = true
		self.content.layer.masksToBounds = true
		
//		super.init(arrangedSubviews: [self.title, self.content])
		super.init(frame: .zero)
		self.axis = .vertical
		self.alignment = alignment
		self.addArrangedSubview(self.title)
		self.addArrangedSubview(self.content)
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setTitle(to newTitle: String, animated: Bool = true) {
		if animated {
			let animation: CATransition = .init()
			animation.duration = 0.3
			animation.type = .fade
			animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
			title.layer.add(animation, forKey: "changeTextTransition")
		}
		title.text = newTitle
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
