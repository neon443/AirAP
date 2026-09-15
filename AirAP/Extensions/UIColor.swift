//
//  UIColor.swift
//  AirAP
//
//  Created by neon443 on 08/09/2026.
//

import Foundation
import UIKit

extension UIColor {
	static var foreground: UIColor {
		let color = UIColor.black
		if #available(iOS 13, *),
		   UIApplication.shared.windows.first!.traitCollection.userInterfaceStyle == .dark {
			return color.inverted
		}
		return color
	}
	
	static var background: UIColor {
		let color = UIColor.white
		if #available(iOS 13, *),
		   UIApplication.shared.windows.first!.traitCollection.userInterfaceStyle == .dark {
			return color.inverted
		}
		return color
	}
	
	var inverted: UIColor {
		var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
		if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
			return UIColor(red: 1.0-r, green: 1.0-g, blue: 1.0-b, alpha: a)
		} else {
			return .clear
		}
	}
}
