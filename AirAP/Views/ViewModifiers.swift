//
//  ViewModifiers.swift
//  AirAP
//
//  Created by neon443 on 04/06/2025.
//

import Foundation
import SwiftUI

@available(iOS 14, *)
struct OverlayIfPossible<V: View>: ViewModifier{
	var alignment: Alignment
	var overlayContent: () -> V
	
	init(alignment: Alignment, overlayContent: @escaping () -> V) {
		self.alignment = alignment
		self.overlayContent = overlayContent
	}
	
	func body(content: Content) -> some View {
		if #available(iOS 15, *) {
			content.overlay(alignment: alignment, content: overlayContent)
		} else {
			content
		}
	}
}

@available(iOS 14, *)
struct AlbumArtGlassEffect: ViewModifier {
	func body(content: Content) -> some View {
		if #available(iOS 19, *) {
			content.glassEffect(in: .rect(cornerRadius: 25))
		} else {
			content
		}
	}
}

@available(iOS 14, *)
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

@available(iOS 14, *)
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

@available(iOS 14, *)
struct backgroundExtensionEffectIfAv: ViewModifier {
	func body(content: Content) -> some View {
		if #available(iOS 19, *) {
			content.backgroundExtensionEffect()
		} else {
			content
		}
	}
}

@available(iOS 14, *)
struct foregroundColorStyle: ViewModifier {
	var color: Color
	
	init(_ color: Color) {
		self.color = color
	}
	
	func body(content: Content) -> some View {
		if #available(iOS 15, *) {
			content.foregroundStyle(color)
		} else {
			content.foregroundColor(color)
		}
	}
}

@available(iOS 14, *)
struct UltraThinMaterialIfAv: ViewModifier {
	func body(content: Content) -> some View {
		if #available(iOS 15, *) {
			content
				.background(.ultraThinMaterial)
		} else {
			content
		}
	}
}

@available(iOS 14, *)
struct MetadataHeading: ViewModifier {
	func body(content: Content) -> some View {
		content
			.modifier(foregroundColorStyle(Color.primary))
			.font(.subheadline)
			.shadow(color: .secondary.opacity(0.5), radius: 3)
	}
}

@available(iOS 14, *)
struct MetadataBody: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.title3)
			.modifier(contentTransitionIfAv())
			.multilineTextAlignment(.leading)
			.shadow(color: .secondary.opacity(0.5), radius: 3)
	}
}
