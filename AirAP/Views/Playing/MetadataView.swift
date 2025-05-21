//
//  MetadataView.swift
//  AirAP
//
//  Created by neon443 on 21/05/2025.
//

import SwiftUI

struct MetadataView: View {
	@ObservedObject var ASmanager: AirstreamManager
	var body: some View {
		VStack(alignment: .leading) {
			Text(ASmanager.title ?? "Not Playing")
				.bold()
				.modifier(NEText())
				.foregroundStyle(
					.primary.opacity(ASmanager.title != nil ? 1 : 0.5)
				)
				.padding(.bottom)
			
			Text("album")
				.modifier(NEHeading())
			Text(ASmanager.album ?? " ")
				.modifier(NEText())
			
			Text("artist")
				.modifier(NEHeading())
			Text(ASmanager.artist ?? " ")
				.modifier(NEText())
			
			Text("sample rate")
				.modifier(NEHeading())
			Text("\(ASmanager.airstream?.sampleRate)")
				.modifier(NEText())
		}
		.padding(.horizontal)
	}
}

#Preview {
    MetadataView(ASmanager: AirstreamManager())
}

fileprivate struct NEHeading: ViewModifier {
	func body(content: Content) -> some View {
		content
			.foregroundStyle(.gray)
			.font(.subheadline)
	}
}

fileprivate struct NEText: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.title3)
			.contentTransition(.numericText())
			.multilineTextAlignment(.center)
	}
}
