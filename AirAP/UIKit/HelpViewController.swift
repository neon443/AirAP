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
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		
		var config = cell.defaultContentConfiguration()
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0:
				config.image = UIImage(systemName: "1.circle")
				config.text = "Open AirPlay picker on other device"
			case 1:
				config.image = UIImage(systemName: "2.circle")
				config.text = "Toggle server on and off"
			default:
				print("row invalid")
			}
		default:
			print("section invalid")
		}
		
		
		cell.contentConfiguration = config
		return cell
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
}
