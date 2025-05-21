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
			
			HStack {
				Spacer()
				VStack {
					Text("sample rate")
						.modifier(NEHeading())
					Text(
						ASmanager.airstream?.sampleRate == nil ||
						ASmanager.airstream?.sampleRate == 0 ?
						"" : "\(ASmanager.airstream!.sampleRate)Hz"
					)
					.modifier(NEText())
				}
				.padding()
				
				VStack {
					Text("bit depth")
						.modifier(NEHeading())
					Text(
						ASmanager.airstream?.bitsPerChannel == nil ||
						ASmanager.airstream?.bitsPerChannel == 0 ?
						"" : "\(ASmanager.airstream!.bitsPerChannel) bit"
					)
					.modifier(NEText())
				}
				VStack {
					Text("channels")
						.modifier(NEHeading())
					Text(
						ASmanager.airstream?.channelsPerFrame == nil ||
						ASmanager.airstream?.channelsPerFrame == 0 ?
						"" : "\(ASmanager.airstream!.channelsPerFrame)"
					)
					.modifier(NEText())
				}
				.padding()
				Spacer()
			}
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
