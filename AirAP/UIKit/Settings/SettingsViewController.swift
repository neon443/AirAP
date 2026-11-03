//
//  SettingsViewController.swift
//  AirAP
//
//  Created by neon443 on 05/09/2026.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
	var startStopButton: ServerStateButton
	
	init() {
		self.startStopButton = ServerStateButton()
		super.init(style: .insetGroupedSafe)
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let category = Category(rawValue: indexPath.section) else { fatalError("invalid section \(indexPath.section)") }
		
		let cell: SettingsCell
	
		let config = category.settingsConfigFor(item: indexPath.row)
		switch config.type {
		case .toggle:
			cell = ToggleSettingsCell(config: config)
		case .slider:
			cell = SliderSettingsCell(config: config)
		case .textField:
			cell = TextFieldSettingsCell(config: config)
		case .segment:
			cell = SegmentedSettingsCell(config: config)
		case .stats:
			cell = StatsSettingsCell(config: config)
		case .macAddress:
			cell = MACAddressSettingsCell(config: config)
		}
		return cell
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard let category = Category(rawValue: section) else { fatalError("invalid section \(section)") }
		return category.description
	}
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		guard let category = Category(rawValue: section) else { fatalError("invalid section \(section)") }
		return category.footnote
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return Category.allCases.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let category = Category(rawValue: section) else { fatalError("invalid section \(section)") }
		return category.contains
	}
	
	func setup() {
		self.tableView.allowsSelection = false
		self.navigationItem.title = "Settings"
	}
	
	override func viewDidLayoutSubviews() {
		self.tableView.contentInset.bottom = 48
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		startStopButton.refreshUI()
	}
	
	override func viewDidLoad() {
		self.view.addSubview(startStopButton)
		startStopButton.translatesAutoresizingMaskIntoConstraints = false
		
		startStopButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
		if #available(iOS 11, *) {
			NSLayoutConstraint.activate([
				startStopButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
				startStopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
			])
		} else {
			NSLayoutConstraint.activate([
				startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				startStopButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
			])
		}
	}
}
