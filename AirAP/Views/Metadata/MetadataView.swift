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
				.modifier(foregroundColorStyle(.clear))
				.modifier(UltraThinMaterialIfAv())
			HStack {
				VStack(alignment: .leading) {
					Text(ASmanager.title ?? "Not Playing")
						.bold()
						.modifier(MetadataBody())
						.modifier(foregroundColorStyle(
							.primary.opacity(ASmanager.title != nil ? 1 : 0.5)
						))
						.padding(.bottom)
					
					Text("album")
						.modifier(MetadataHeading())
					Text(ASmanager.album ?? " ")
						.modifier(MetadataBody())
					
					Text("artist")
						.modifier(MetadataHeading())
					Text(ASmanager.artist ?? " ")
						.modifier(MetadataBody())
					
					if settingsModel.showAudioQuality {
						HStack {
							Spacer()
							VStack {
								Text("sample rate")
									.modifier(MetadataHeading())
								Text(
									ASmanager.airstream?.sampleRate == nil ||
									ASmanager.airstream?.sampleRate == 0 ?
									"" : "\(ASmanager.airstream!.sampleRate)Hz"
								)
								.modifier(MetadataBody())
							}
							.padding()
							
							VStack {
								Text("bit depth")
									.modifier(MetadataHeading())
								Text(
									ASmanager.airstream?.bitsPerChannel == nil ||
									ASmanager.airstream?.bitsPerChannel == 0 ?
									"" : "\(ASmanager.airstream!.bitsPerChannel) bit"
								)
								.modifier(MetadataBody())
							}
							VStack {
								Text("channels")
									.modifier(MetadataHeading())
								Text(
									ASmanager.airstream?.channelsPerFrame == nil ||
									ASmanager.airstream?.channelsPerFrame == 0 ?
									"" : "\(ASmanager.airstream!.channelsPerFrame)"
								)
								.modifier(MetadataBody())
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
