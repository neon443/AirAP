//
//  ColorAdjustments.swift
//  AirAP
//
//  Created by neon443 on 26/05/2025.
//

import Foundation
import SwiftUI

extension Color {
	func luminance() -> Double {
		let uiColor = UIColor(self)
		
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		
		uiColor.getRed(&r, green: &g, blue: &b, alpha: nil)
		return r*0.2126 + g*0.7152 + b*0.0722
	}
	
	func isLight() -> Bool {
		return luminance() > 0.5
	}
	
	func adaptedTextColor() -> Color {
		return isLight() ? .black : .white
	}
}
