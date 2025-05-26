//
//  Portrait.swift
//  AirAP
//
//  Created by neon443 on 26/05/2025.
//

import SwiftUI

struct Portrait: View {
	@ObservedObject var ASmanager: AirstreamManager
	@ObservedObject var settingsModel: AAPSettingsModel
	@State var geoSize: CGSize
	
	var body: some View {
		ZStack(alignment: .center) {
			if ASmanager.albumArt != nil, let art = ASmanager.albumArt {
				Image(uiImage: art)
					.resizable()
					.ignoresSafeArea(.all)
					.scaledToFill()
					.blur(radius: settingsModel.bgBlur)
					.clipped()
					.opacity(settingsModel.showBg ? settingsModel.bgOpacity : 0)
					.frame(maxWidth: geoSize.width, maxHeight: geoSize.height)
			}
			
			VStack(alignment: .center) {
				AlbumArtView(ASmanager: ASmanager)
					.frame(
						maxWidth: geoSize.width*0.8,
						maxHeight: geoSize.width*0.8
					)
				
				if settingsModel.showMetadata {
					MetadataView(
						ASmanager: ASmanager,
						settingsModel: settingsModel
					)
				}
				
				Spacer()
				
				if ASmanager.canControl {
					PlaybackControls(ASmanager: ASmanager)
				}
				
				Spacer()
				StartStopButton(ASmanager: ASmanager)
			}
		}
	}
}

#Preview {
	GeometryReader { geo in
		Portrait(
			ASmanager: AirstreamManager(),
			settingsModel: AAPSettingsModel(),
			geoSize: geo.size
		)
	}
}
