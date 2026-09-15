//
//  UITableView.swift
//  AirAP
//
//  Created by neon443 on 08/09/2026.
//

import Foundation
import UIKit

extension UITableView.Style {
	static var insetGroupedSafe: UITableView.Style {
		if #available(iOS 13, *) {
			return .insetGrouped
		} else {
			return .grouped
		}
	}
}
