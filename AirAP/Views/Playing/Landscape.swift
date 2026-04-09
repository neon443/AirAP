//
//  Portrait.swift
//  AirAP
//
//  Created by neon443 on 26/05/2025.
//

import SwiftUI

@available(iOS 14, *)
struct Landscape: View {
	@ObservedObject var ASmanager: AirstreamManager
	@State var geoSize: CGSize
	
    var body: some View {
		ZStack(alignment: .center) {
			//bg
			if ASmanager.albumArt != nil, let art = ASmanager.albumArt {
				Image(uiImage: art)
					.resizable()
					.ignoresSafeArea(.all)
					.scaledToFill()
					.blur(radius: ASmanager.settings.bgBlur)
					.clipped()
					.opacity(ASmanager.settings.showBg ? ASmanager.settings.bgOpacity : 0)
					.frame(maxWidth: geoSize.width, maxHeight: geoSize.height)
					.modifier(backgroundExtensionEffectIfAv())
			}
			HStack(alignment: .center, spacing: 5) {
				AlbumArtView(ASmanager: ASmanager)
					.frame(maxWidth: geoSize.width*0.5)
					.aspectRatio(1, contentMode: .fit)
					.padding(.top)
				
				VStack {
					if ASmanager.settings.showMetadata {
						MetadataView(
							ASmanager: ASmanager
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
}

@available(iOS 17, *)
#Preview(traits: .landscapeRight) {
	GeometryReader { geo in
		Landscape(
			ASmanager: AirstreamManager(),
			geoSize: geo.size
		)
	}
}
