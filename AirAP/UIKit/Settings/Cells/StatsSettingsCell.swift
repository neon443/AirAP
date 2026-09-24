//
//  StatsSettingsCell.swift
//  AirAP
//
//  Created by neon443 on 17/09/2026.
//

import Foundation
import UIKit

class StatsSettingsCell: SettingsCell {
	var port: StatRow
	var serverIP: StatRow
	var clientIP: StatRow
	
	var stack: UIStackView
	
	override init(asManager: AirstreamManager, config: SettingsViewController.SettingsConfiguration) {
		self.port = StatRow(title: "Port")
		self.serverIP = StatRow(title: "Server")
		self.clientIP = StatRow(title: "Client")
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
		
		stack.addArrangedSubview(serverIP)
		stack.addArrangedSubview(clientIP)
		stack.addArrangedSubview(port)
		
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
		port.setContent(to: "\(asManager.airstream!.port)")
		serverIP.setContent(to: getIPAddress())
		clientIP.setContent(to: asManager.airstream?.remote?.hostName)
	}
	
	class StatRow: UIStackView {
		var title: UILabel = .init()
		var content: UILabel = .init()
		
		init(title: String) {
			super.init(frame: .zero)
			self.addArrangedSubview(self.title)
			self.addArrangedSubview(self.content)
			self.axis = .horizontal
			self.distribution = .equalSpacing
			self.title.text = title
			self.content.textColor = .gray
		}
		
		required init(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		func setContent(to newContent: String?) {
			content.text = newContent
		}
	}
}
