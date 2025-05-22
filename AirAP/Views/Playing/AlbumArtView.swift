//
//  AlbumArtView.swift
//  AirAP
//
//  Created by neon443 on 22/05/2025.
//

import SwiftUI

struct AlbumArtView: View {
	@ObservedObject var ASmanager: AirstreamManager
	@State var geoSize: CGSize
	
	var body: some View {
		VStack(alignment: .center) {
			ZStack {
				RoundedRectangle(cornerRadius: 25)
					.frame(
						width: geoSize.width*0.8,
						height: geoSize.width*0.8
					)
					.foregroundStyle(.gray.opacity(0.5))
				Image(systemName: "music.note")
					.resizable()
					.scaledToFit()
					.frame(
						width: geoSize.width*0.4,
						height: geoSize.width*0.4
					)
					.foregroundStyle(.gray.opacity(0.8))
				if let image = ASmanager.albumArt {
					Image(uiImage: image)
						.resizable()
						.scaledToFit()
						.frame(
							width: geoSize.width*0.75,
							height: geoSize.width*0.75
						)
						.clipShape(RoundedRectangle(
							cornerRadius: (25-geoSize.width*0.025)
						))
						.shadow(radius: 5)
						.transition(.scale)
				}
			}
			.animation(.spring, value: ASmanager.album)
			.padding(.bottom)
			
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

#Preview {
	GeometryReader { geo in
		AlbumArtView(
			ASmanager: AirstreamManager(),
			geoSize: geo.size
		)
	}
}
