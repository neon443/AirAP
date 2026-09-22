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
	
	// Source - https://stackoverflow.com/a/73853768
	func getIPAddress() -> String? {
		var address : String?
		var ifaddr : UnsafeMutablePointer<ifaddrs>?
		guard getifaddrs(&ifaddr) == 0 else { return nil }
		guard let firstAddr = ifaddr else { return nil }

		for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
			let interface = ifptr.pointee
			let addrFamily = interface.ifa_addr.pointee.sa_family
			if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

				// wifi = ["en0"]
				// wired = ["en2", "en3", "en4"]
				// cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
				let name = String(cString: interface.ifa_name)
				if  name == "en0" {
					var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
					getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
								&hostname, socklen_t(hostname.count),
								nil, socklen_t(0), NI_NUMERICHOST)
					address = String(cString: hostname)
				}
			}
		}
		freeifaddrs(ifaddr)
		return address
	}

	
	func setup() {
		stack.axis = .vertical
		
		serverIP.textColor = .gray
		clientIP.textColor = .gray
		
		let serverIPLabel = UILabel()
		serverIPLabel.text = "Server"
		let serverIPStack = UIStackView(arrangedSubviews: [serverIPLabel, serverIP])
		serverIPStack.axis = .horizontal
		serverIPStack.distribution = .equalSpacing
		
		let clientIPLabel = UILabel()
		clientIPLabel.text = "Client"
		let clientIPStack = UIStackView(arrangedSubviews: [clientIPLabel, clientIP])
		clientIPStack.axis = .horizontal
		clientIPStack.distribution = .equalSpacing
		
		stack.addArrangedSubview(serverIPStack)
		stack.addArrangedSubview(clientIPStack)
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
		portLabel.text = "\(asManager.airstream!.port)"
		serverIP.text = getIPAddress() ?? "_"
		clientIP.text = asManager.airstream?.remote?.hostName
	}
	
	private class StatRow: UIStackView {
		var title: UILabel = .init()
		var content: UILabel = .init()
		
		init(title: String) {
			super.init(frame: .zero)
			self.addArrangedSubview(self.title)
			self.addArrangedSubview(self.content)
		}
		
		required init(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		func setTitle(to newTitle: String) {
			title.text = newTitle
		}
		
		func setContent(to newTitle: String) {
		}
	}
}
