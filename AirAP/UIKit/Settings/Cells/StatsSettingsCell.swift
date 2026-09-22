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
	
	// Source - https://stackoverflow.com/a/25627545
	func getIFAddresses() -> [String] {
		var addresses = [String]()

		var ifaddr : UnsafeMutablePointer<ifaddrs>?
		guard getifaddrs(&ifaddr) == 0 else { return [] }
		guard let firstAddr = ifaddr else { return [] }

		for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
			let flags = Int32(ptr.pointee.ifa_flags)
			let addr = ptr.pointee.ifa_addr.pointee

			if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
				if addr.sa_family == UInt8(AF_INET){

					var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
					if (getnameinfo(ptr.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
									nil, socklen_t(0), NI_NUMERICHOST) == 0) {
						let address = String(cString: hostname)
						addresses.append(address)
					}
				}
			}
		}

		freeifaddrs(ifaddr)
		return addresses
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
		self.serverIP.text = getIFAddresses().joined(separator: "_")
	}
}
