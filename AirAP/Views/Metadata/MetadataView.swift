//
//  MetadataView.swift
//  AirAP
//
//  Created by neon443 on 21/05/2025.
//

import SwiftUI

struct MetadataView: View {
	@ObservedObject var ASmanager: AirstreamManager
	@ObservedObject var settingsModel: AAPSettingsModel
	
	var body: some View {
		ZStack {
			Rectangle()
				.opacity(0.8)
				.foregroundStyle(.clear)
				.background(.ultraThinMaterial)
//				.blur(radius: 5)
			HStack {
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
					
					if settingsModel.showAudioQuality {
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
				}
				.padding(10)
				Spacer()
			}
		}
		.fixedSize(horizontal: false, vertical: true)
	}
}

#Preview {
	MetadataView(
		ASmanager: AirstreamManager(),
		settingsModel: AAPSettingsModel()
	)
}

fileprivate struct NEHeading: ViewModifier {
	func body(content: Content) -> some View {
		content
			.foregroundStyle(.foreground)
			.font(.subheadline)
			.shadow(color: .secondary.opacity(0.5), radius: 3)
	}
}

fileprivate struct NEText: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.title3)
			.contentTransition(.numericText())
			.multilineTextAlignment(.leading)
			.shadow(radius: 3)
	}
}
