//
//  HelpViewController.swift
//  AirAP
//
//  Created by neon443 on 05/09/2026.
//

import Foundation
import UIKit

class HelpViewController: UITableViewController {
	init() {
		super.init(style: .insetGrouped)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	enum Topic: Int, CaseIterable {
		case doesNotAppear = 0
		case runOnOldDevice = 1
		case iHaveFeedback = 2
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		
		var config = cell.defaultContentConfiguration()
		
		let topic = Topic(rawValue: indexPath.section)
		switch topic {
		case .doesNotAppear:
			if indexPath.row == 0 {
				config.image = UIImage(systemName: "1.circle")
				config.text = "Open AirPlay picker on other device"
			} else {
				config.image = UIImage(systemName: "2.circle")
				config.text = "Toggle server on and off"
			}
		case .runOnOldDevice:
			config.text = "Sideload the .ipa file from GitHub"
		case .iHaveFeedback:
			config.text = "Submit feedback via TestFlight, or open a GitHub issue"
		case nil:
			fatalError("invalid section \(indexPath) to topic")
		}
		
		cell.contentConfiguration = config
		return cell
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return Topic.allCases.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let topic = Topic(rawValue: section)
		switch topic {
		case .doesNotAppear:
			return 2
		case .runOnOldDevice, .iHaveFeedback:
			return 1
		case nil:
			fatalError("invalid section \(section) to topic")
		}
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let topic = Topic(rawValue: section)
		switch topic {
		case .doesNotAppear:
			return "Does not appear in AirPlay picker"
		case .runOnOldDevice:
			return "Run server on old iOS devices"
		case .iHaveFeedback:
			return "I have feedback!"
		case nil:
			fatalError("invalid section \(section) to topic")
		}
	}
	
	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let topic = Topic(rawValue: section)
		switch topic {
		case .doesNotAppear:
			return nil
		case .runOnOldDevice:
			let button = UIButton(type: .custom)
			button.addTarget(self, action: #selector(openReleses), for: .touchUpInside)
			button.setTitle("Open GitHub", for: .normal)
			button.setTitleColor(.systemBlue, for: .normal)
			return button
		case .iHaveFeedback:
			let button = UIButton(type: .custom)
			button.addTarget(self, action: #selector(createAnIssue), for: .touchUpInside)
			button.setTitle("Create a GitHub issue", for: .normal)
			button.setTitleColor(.systemBlue, for: .normal)
			return button
		case nil:
			fatalError("invalid section \(section) to topic")
		}
	}
	
	@objc func openReleses() {
		UIApplication.shared.open(URL(string: "https://github.com/neon443/AirAP/releases/latest")!)
	}
	
	@objc func createAnIssue() {
		UIApplication.shared.open(URL(string: "https://github.com/neon443/AirAP/issues/new/choose")!)
	}
}
