//
//  StatsSettingsCell.swift
//  AirAP
//
//  Created by neon443 on 17/09/2026.
//

import Foundation
import UIKit

class StatsSettingsCell: SettingsCell {
	var portLabel: UILabel
	var serverIP: UILabel
	var clientIP: UILabel
	
	var stack: UIStackView
	
	override init(asManager: AirstreamManager, config: SettingsViewController.SettingsConfiguration) {
		self.portLabel = UILabel()
		self.serverIP = UILabel()
		self.clientIP = UILabel()
		self.stack = UIStackView()
		
		super.init(asManager: asManager, config: config)
		
		setup()
		refreshUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		stack.axis = .vertical
		
		let serverIPLabel = UILabel()
		serverIPLabel.text = "Server IP"
		let serverIPStack = UIStackView(arrangedSubviews: [serverIPLabel, serverIP])
		serverIPStack.distribution = .equalSpacing
		
		let clientIPLabel = UILabel()
		clientIPLabel.text = "Client IP"
		let clientIPStack = UIStackView(arrangedSubviews: [clientIPLabel, clientIP])
		clientIPStack.distribution = .equalSpacing
		
		stack.addArrangedSubview(serverIPLabel)
		stack.addArrangedSubview(clientIPLabel)
		stack.addArrangedSubview(portLabel)
		contentView.addSubview(stack)
		stack.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
			stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
			stack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
			stack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
		])
	}
	
	override func refreshUI() {
		super.refreshUI()
//		clientIP = asManager.airstream
		portLabel.text = "\(asManager.airstream!.port)"
	}
}
