//
//  UIApplication.swift
//  AirAP
//
//  Created by neon443 on 10/09/2026.
//

import Foundation
import UIKit

extension UIApplication {
	func safeOpenURL(_ url: URL?) {
		guard let url = url else { return }
		if #available(iOS 10, *) {
			UIApplication.shared.open(url)
		} else {
			UIApplication.shared.openURL(url)
		}
	}
}
