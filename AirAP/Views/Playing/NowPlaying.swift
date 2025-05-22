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
			ZStack(alignment: .center) {
				if ASmanager.albumArt != nil, let art = ASmanager.albumArt {
					Image(uiImage: art)
						.resizable()
						.ignoresSafeArea(.all)
						.scaledToFill()
						.blur(radius: 75)
						.clipped()
						.opacity(0.8)
						.frame(maxWidth: geo.size.width, maxHeight: geo.size.height)
				}
				AlbumArtView(ASmanager: ASmanager, geoSize: geo.size)
			}
		}
	}
}

#Preview {
	NowPlaying(
		ASmanager: AirstreamManager()
	)
}
