//
//  Now Playing.swift
//  AirAP
//
//  Created by neon443 on 20/05/2025.
//

import SwiftUI
import ActivityKit

struct NowPlaying: View {
	@ObservedObject var ASmanager: AirstreamManager
	@ObservedObject var settingsModel: AAPSettingsModel
	
	var body: some View {
		GeometryReader { geo in
			ZStack(alignment: .center) {
				if ASmanager.albumArt != nil, let art = ASmanager.albumArt {
					Image(uiImage: art)
						.resizable()
						.ignoresSafeArea(.all)
						.scaledToFill()
						.blur(radius: settingsModel.bgBlur)
						.clipped()
						.opacity(settingsModel.showBg ? settingsModel.bgOpacity : 0)
						.frame(maxWidth: geo.size.width, maxHeight: geo.size.height)
				}
				
				VStack(alignment: .center) {
					AlbumArtView(ASmanager: ASmanager, geoSize: geo.size)
					
					MetadataView(ASmanager: ASmanager)
					
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
}

#Preview {
	NowPlaying(
		ASmanager: AirstreamManager(),
		settingsModel: AAPSettingsModel()
	)
}
