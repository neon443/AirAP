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
	var stepLabel: UILabel?
	var leadingStack: UIStackView?
	var stack: UIStackView?
	
	init(title: String, stepNumber: Int) {
		self.title = UILabel()
		
		self.stepLabel = UILabel()
		self.leadingStack = UIStackView(arrangedSubviews: [self.stepLabel!, self.title])
		self.stack = UIStackView(arrangedSubviews: [leadingStack!, UIView()])
		
		super.init(style: .default, reuseIdentifier: nil)
		
		self.title.text = title
		
		self.stepLabel?.text = "\(stepNumber)"
		self.stepLabel?.font = self.title.font.withWeight(.bold).withSize(self.title.font.pointSize + 4)
		self.stepLabel?.textColor = .systemBlue
		
		leadingStack?.spacing = 8
		stack!.axis = .horizontal
		stack!.distribution = .equalSpacing
		
		self.contentView.addSubview(stack!)
		stack!.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			stack!.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
			stack!.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
			stack!.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
			stack!.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
		])
	}
	
	init(title: String) {
		self.title = UILabel()
		
		super.init(style: .default, reuseIdentifier: nil)
		
		self.title.text = title
		
		self.contentView.addSubview(self.title)
		self.title.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.title.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
			self.title.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
			self.title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
			self.title.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		if let stepLabel = stepLabel,
		   let leadingStack = leadingStack {
			self.separatorInset.left = self.layoutMargins.left + stepLabel.bounds.width + leadingStack.spacing
		}
	}
}
