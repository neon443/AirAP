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
				if #unavailable(iOS 19) {
					RoundedRectangle(cornerRadius: 25)
						.frame(
							maxWidth: geo.size.width,
							maxHeight: geo.size.height
						)
						.modifier(foregroundColorStyle(.gray.opacity(0.5)))
				}
				Image(systemName: "music.note")
					.resizable()
					.scaledToFit()
					.frame(
						width: geo.size.width*0.25,
						height: geo.size.height*0.25
					)
					.padding(.horizontal, geo.size.width/2 - geo.size.width*0.125)
					.padding(.vertical, geo.size.width/2 - geo.size.height*0.125)
					.modifier(AlbumArtGlassEffect())
					.modifier(foregroundColorStyle(.gray.opacity(0.8)))
				if let image = ASmanager.albumArt {
					Image(uiImage: image)
						.resizable()
						.scaledToFit()
						.frame(
							width: geo.size.width*0.97,
							height: geo.size.height*0.97
						)
						.clipShape(RoundedRectangle(
							cornerRadius: 25-((geo.size.width*0.015)/2)
						))
//						.shadow(radius: 5)
						.transition(.scale)
				}
			}
		}
		.animation(.spring, value: ASmanager.album)
		.padding(.bottom)	
	}
}

#Preview {
	ZStack(alignment: .center) {
		Color.orange
		GeometryReader { geo in
			AlbumArtView(
				ASmanager: AirstreamManager()
			)
		}
	}
}
