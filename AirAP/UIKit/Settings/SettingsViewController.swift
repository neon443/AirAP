//
//  SettingsViewController.swift
//  AirAP
//
//  Created by neon443 on 05/09/2026.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
	var asManager: AirstreamManager
	var startStopButton: ServerStateButton
	
	init(asManager: AirstreamManager) {
		self.asManager = asManager
		self.startStopButton = ServerStateButton(asManager: asManager)
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
			cell = ToggleSettingsCell(asManager: asManager, config: config)
		case .slider:
			cell = SliderSettingsCell(asManager: asManager, config: config)
		case .textField:
			cell = TextFieldSettingsCell(asManager: asManager, config: config)
		case .segment:
			cell = SegmentedSettingsCell(asManager: asManager, config: config)
		case .stats:
			cell = StatsSettingsCell(asManager: asManager, config: config)
		case .macAddress:
			cell = MACAddressSettingsCell(asManager: asManager, config: config)
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
}
