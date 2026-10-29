//
//  NSLayoutConstraint.swift
//  AirAP
//
//  Created by neon443 on 29/10/2026.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
	func activate() {
		self.isActive = true
	}
	
	func deactivate() {
		self.isActive = false
	}
}
