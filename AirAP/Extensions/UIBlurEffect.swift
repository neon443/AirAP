//
//  UIBlurEffect.swift
//  AirAP
//
//  Created by neon443 on 08/09/2026.
//

import Foundation
import UIKit

extension UIBlurEffect.Style {
	static var systemUltraThinMaterialSafe: UIBlurEffect.Style {
		if #available(iOS 13, *) {
			return self.systemUltraThinMaterial
		} else {
			return self.light
		}
	}
	
	static var systemThinMaterialSafe: UIBlurEffect.Style {
		if #available(iOS 13, *) {
			return self.systemThinMaterial
		} else {
			return self.light
		}
	}
	
	static var systemMaterialSafe: UIBlurEffect.Style {
		if #available(iOS 13, *) {
			return self.systemMaterial
		} else {
			return self.light
		}
	}
	
	static var systemChromeMaterialSafe: UIBlurEffect.Style {
		if #available(iOS 13, *) {
			return self.systemChromeMaterial
		} else {
			return self.light
		}
	}
}
