//
//  Portrait.swift
//  AirAP
//
//  Created by neon443 on 26/05/2025.
//

import SwiftUI

struct Landscape: View {
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
			HStack(alignment: .center) {
				AlbumArtView(ASmanager: ASmanager)
					.padding()
					.frame(maxWidth: geoSize.width*0.5, maxHeight: geoSize.width*0.5)
				
				VStack {
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
//		ZStack(alignment: .center) {
//			if ASmanager.albumArt != nil, let art = ASmanager.albumArt {
//				Image(uiImage: art)
//					.resizable()
//					.ignoresSafeArea(.all)
//					.scaledToFill()
//					.blur(radius: settingsModel.bgBlur)
//					.clipped()
//					.opacity(settingsModel.showBg ? settingsModel.bgOpacity : 0)
//					.frame(maxWidth: geoSize.width*0.5, maxHeight: geoSize.height)
//			}
//			
//			HStack(alignment: .center) {
//				AlbumArtView(ASmanager: ASmanager, geoSize: geoSize)
//				
//				
//				
//				if settingsModel.showMetadata {
//					MetadataView(
//						ASmanager: ASmanager,
//						settingsModel: settingsModel
//					)
//				}
//				
//				Spacer()
//				
//				if ASmanager.canControl {
//					PlaybackControls(ASmanager: ASmanager)
//				}
//				
//				Spacer()
//				StartStopButton(ASmanager: ASmanager)
//			}
//		}
	}
}

#Preview {
	GeometryReader { geo in
		Landscape(
			ASmanager: AirstreamManager(),
			settingsModel: AAPSettingsModel(),
			geoSize: geo.size
		)
	}
}
