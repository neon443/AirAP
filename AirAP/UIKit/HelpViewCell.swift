//
//  HelpViewCell.swift
//  AirAP
//
//  Created by neon443 on 08/09/2026.
//

import Foundation
import UIKit

class HelpViewCell: UITableViewCell {
	var title: UILabel
	var image: UIImageView?
	var stack: UIStackView
	
	init(title: String, image: UIImage? = nil) {
		self.title = UILabel()
		
		if image == nil {
			self.stack = UIStackView(arrangedSubviews: [self.title])
		} else {
			self.image = UIImageView(image: image)
			self.stack = UIStackView(arrangedSubviews: [self.title, self.image!])
		}
		
		super.init(style: .default, reuseIdentifier: nil)
		
		self.title.text = title
		
		stack.axis = .horizontal
		self.contentView.addSubview(stack)
		stack.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			stack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
			stack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
			stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
			stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}
