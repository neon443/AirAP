//
//  UIFont.swift
//  AirAP
//
//  Created by neon443 on 07/09/2026.
//

import Foundation
import UIKit

extension UIFont {
	static func preferredFont(forTextStyle style: UIFont.TextStyle, andWeight weight: UIFont.Weight) -> UIFont {
		let font = UIFont.preferredFont(forTextStyle: style)
		return font.withWeight(weight)
	}
	
	func withWeight(_ weight: UIFont.Weight) -> UIFont {
		let newDescriptor = self.fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: weight]])
		return UIFont(descriptor: newDescriptor, size: self.pointSize)
	}
}
