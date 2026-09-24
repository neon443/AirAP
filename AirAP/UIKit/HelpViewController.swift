//
//  HelpViewController.swift
//  AirAP
//
//  Created by neon443 on 05/09/2026.
//

import Foundation
import UIKit

class HelpViewController: UITableViewController {
	var asManager: AirstreamManager
	var startStopButton: ServerStateButton
	
	init(asManager: AirstreamManager) {
		self.asManager = asManager
		self.startStopButton = .init(asManager: asManager)
		super.init(style: .insetGroupedSafe)
		self.tableView.register(HelpViewCell.self, forCellReuseIdentifier: "helpCell")
		setup()
		refreshUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		self.navigationItem.title = "Help"
		self.tableView.allowsSelection = false
		self.view.addSubview(startStopButton)
		startStopButton.translatesAutoresizingMaskIntoConstraints = false
		
		startStopButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
		if #available(iOS 11, *) {
			NSLayoutConstraint.activate([
				startStopButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
				startStopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
			])
		} else {
			NSLayoutConstraint.activate([
				startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				startStopButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
			])
		}
	}
	
	func refreshUI() {
		startStopButton.refreshUI()
	}
	
	@objc func openReleses() {
		UIApplication.shared.safeOpenURL(URL(string: "https://github.com/neon443/AirAP/releases/latest")!)
	}
	
	@objc func createAnIssue() {
		UIApplication.shared.safeOpenURL(URL(string: "https://github.com/neon443/AirAP/issues/new/choose")!)
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
				cell = .init(title: "Open AirPlay picker on other device", stepNumber: 1)
			} else {
				cell = .init(title: "Toggle server on and off", stepNumber: 2)
			}
		case .runOnOldDevice:
			cell = .init(title: "Sideload the .ipa file from GitHub")
		case .iHaveFeedback:
			cell = .init(title: "Submit on TestFlight, or open a GitHub issue")
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
			return "Not appearing in AirPlay picker"
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.refreshUI()
	}
}
