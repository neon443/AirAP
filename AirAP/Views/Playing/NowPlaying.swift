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
	
	var body: some View {
		GeometryReader { geo in
			VStack(alignment: .center) {
				ZStack {
					RoundedRectangle(cornerRadius: 25)
						.frame(
							width: geo.size.width*0.8,
							height: geo.size.width*0.8
						)
						.foregroundStyle(.gray.opacity(0.5))
					Image(systemName: "music.note")
						.resizable()
						.scaledToFit()
						.frame(
							width: geo.size.width*0.4,
							height: geo.size.width*0.4
						)
						.foregroundStyle(.gray.opacity(0.8))
					if let image = ASmanager.albumArt {
						Image(uiImage: image)
							.resizable()
							.scaledToFit()
							.frame(
								width: geo.size.width*0.75,
								height: geo.size.width*0.75
							)
							.clipShape(RoundedRectangle(
								cornerRadius: (25-geo.size.width*0.025)
							))
							.shadow(radius: 5)
							.transition(.scale)
					}
				}
				.animation(.spring, value: ASmanager.album)
				.padding(.bottom)

				MetadataView(ASmanager: ASmanager)
				
				Spacer()
				
				PlaybackControls(ASmanager: ASmanager)
				
				Spacer()
				StartStopButton(ASmanager: ASmanager)
			}
		}
	}
}

#Preview {
	NowPlaying(
		ASmanager: AirstreamManager()
	)
}
