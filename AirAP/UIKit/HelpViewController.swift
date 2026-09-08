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
		self.tableView.allowsSelection = false
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
		let cell: HelpViewCell
		
		let topic = Topic(rawValue: indexPath.section)
		switch topic {
		case .doesNotAppear:
			if indexPath.row == 0 {
				cell = .init(title: "Open AirPlay picker on other device", image: UIImage(systemName: "1.circle"))
			} else {
				cell = .init(title: "Toggle server on and off", image: UIImage(systemName: "2.circle"))
			}
		case .runOnOldDevice:
			cell = .init(title: "Sideload the .ipa file from GitHub")
		case .iHaveFeedback:
			cell = .init(title: "Submit feedback via TestFlight, or open a GitHub issue")
		case nil:
			fatalError("invalid section \(indexPath) to topic")
		}
		
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
		let button = UIButton(type: .custom)
		switch topic {
		case .doesNotAppear:
			return nil
		case .runOnOldDevice:
			button.addTarget(self, action: #selector(openReleses), for: .touchUpInside)
			button.setTitle("Open GitHub", for: .normal)
		case .iHaveFeedback:
			button.addTarget(self, action: #selector(createAnIssue), for: .touchUpInside)
			button.setTitle("Create a GitHub issue", for: .normal)
		default:
			fatalError("invalid section \(section) to topic")
		}
		button.setTitleColor(.systemBlue, for: .normal)
		return button
	}
	
	@objc func openReleses() {
		UIApplication.shared.open(URL(string: "https://github.com/neon443/AirAP/releases/latest")!)
	}
	
	@objc func createAnIssue() {
		UIApplication.shared.open(URL(string: "https://github.com/neon443/AirAP/issues/new/choose")!)
	}
}
