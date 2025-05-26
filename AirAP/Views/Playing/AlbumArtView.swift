//
//  AlbumArtView.swift
//  AirAP
//
//  Created by neon443 on 22/05/2025.
//

import SwiftUI

struct AlbumArtView: View {
	@ObservedObject var ASmanager: AirstreamManager
	
	var body: some View {
		GeometryReader { geo in
			ZStack {
				RoundedRectangle(cornerRadius: 25)
					.frame(
						maxWidth: .infinity,
						maxHeight: .infinity
					)
					.foregroundStyle(.gray.opacity(0.5))
				Image(systemName: "music.note")
					.resizable()
					.scaledToFit()
					.frame(
						width: geo.size.width*0.5,
						height: geo.size.height*0.5
					)
					.foregroundStyle(.gray.opacity(0.8))
				if let image = ASmanager.albumArt {
					Image(uiImage: image)
						.resizable()
						.scaledToFit()
						.frame(
							width: geo.size.width*0.9,
							height: geo.size.height*0.9
						)
						.clipShape(RoundedRectangle(
							cornerRadius: (25-geo.size.width*0.05)
						))
						.shadow(radius: 5)
						.transition(.scale)
				}
			}
		}
		.animation(.spring, value: ASmanager.album)
		.padding(.bottom)	
	}
}

#Preview {
	GeometryReader { geo in
		AlbumArtView(
			ASmanager: AirstreamManager()
		)
	}
}
