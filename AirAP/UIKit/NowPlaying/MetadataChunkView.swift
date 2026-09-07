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
		self.title.font = UIFont.preferredFont(forTextStyle: .title3, andWeight: .light)
		self.title.layer.shadowColor = UIColor(named: "background")?.cgColor
		self.title.layer.shadowOpacity = 0.5
		self.title.layer.shadowRadius = 3
		
		self.content = UILabel()
		self.content.text = title
		self.title.font = UIFont.preferredFont(forTextStyle: .subheadline, andWeight: .light)
		self.content.layer.shadowColor = UIColor(named: "background")?.cgColor
		self.content.layer.shadowOpacity = 0.5
		self.content.layer.shadowRadius = 3
		
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
			UIView.transition(with: title, duration: 0.2) {
				self.title.text = newTitle
			}
		} else {
			title.text = newTitle
		}
	}
	
	func setContent(to newContent: String?, animated: Bool = true) {
		if animated {
			UIView.transition(with: title, duration: 0.2) {
				self.content.text = newContent
			}
		} else {
			content.text = newContent
		}
	}
}
