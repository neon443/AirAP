//
//  MetadataAudioChunk.swift
//  AirAP
//
//  Created by neon443 on 23/09/2026.
//

import Foundation
import UIKit

class MetadataAudioChunk: UIStackView {
	var title: UILabel
	var content: UILabel
	
	enum AudioProperty: CustomStringConvertible {
		case sampleRate
		case bitDepth
		case channels
		
		var description: String {
			switch self {
			case .sampleRate:
				return "sample rate"
			case .bitDepth:
				return "bit depth"
			case .channels:
				return "channels"
			}
		}
	}
	
	init(
		type: AudioProperty,
		content: String? = nil,
	) {
		self.title = UILabel()
		self.title.text = type.description
		self.title.font = UIFont.preferredFont(forTextStyle: .subheadline, andWeight: .light)
		self.title.layer.shadowColor = UIColor.background.cgColor
		self.title.layer.shadowOpacity = 0.5
		self.title.layer.shadowRadius = 3
		self.title.clipsToBounds = true
		self.title.layer.masksToBounds = true
		
		self.content = UILabel()
		self.content.text = "._."
		self.content.font = UIFont.preferredFont(forTextStyle: .title3)
		self.content.layer.shadowColor = UIColor.background.cgColor
		self.content.layer.shadowOpacity = 0.5
		self.content.layer.shadowRadius = 3
		self.content.clipsToBounds = true
		self.content.layer.masksToBounds = true
		
		super.init(frame: .zero)
		
		self.axis = .vertical
		self.alignment = .center
		
		self.addArrangedSubview(self.title)
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
