//
//  ViewModifiers.swift
//  AirAP
//
//  Created by neon443 on 04/06/2025.
//

import Foundation
import SwiftUI

struct contentTransitionIfAv: ViewModifier {
	func body(content: Content) -> some View {
		if #available(iOS 16, *) {
			content
				.contentTransition(.numericText())
		} else {
			content
		}
	}
}

struct monospacedIfAv: ViewModifier {
	func body(content: Content) -> some View {
		if #available(iOS 16, *) {
			content
				.monospaced()
		} else {
			content
				.font(.system(.body, design: .monospaced))
		}
	}
}
