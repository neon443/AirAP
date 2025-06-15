//
//  AlbumArtView.swift
//  AirAP
//
//  Created by neon443 on 22/05/2025.
//

import SwiftUI

struct AlbumArtView: View {
	@ObservedObject var ASmanager: AirstreamManager
	let padding: CGFloat = 10
	
	var body: some View {
		GeometryReader { geo in
			let minWidthHeight = min(geo.size.width, geo.size.height)
			ZStack {
				if #unavailable(iOS 19) {
					RoundedRectangle(cornerRadius: 25)
						.frame(
							maxWidth: minWidthHeight,
							maxHeight: minWidthHeight
						)
						.modifier(foregroundColorStyle(.gray.opacity(0.5)))
				}
				Image(systemName: "music.note")
					.resizable()
					.scaledToFit()
					.frame(
						width: minWidthHeight*0.25,
						height: minWidthHeight*0.25
					)
					.padding(.horizontal, minWidthHeight/2 - minWidthHeight*0.125)
					.padding(.vertical, minWidthHeight/2 - minWidthHeight*0.125)
					.modifier(AlbumArtGlassEffect())
					.modifier(foregroundColorStyle(.gray.opacity(0.8)))
				if let image = ASmanager.albumArt {
					Image(uiImage: image)
						.resizable()
						.scaledToFit()
						.frame(
							width: minWidthHeight-(2*padding),
							height: minWidthHeight-(2*padding)
						)
						.clipShape(RoundedRectangle(
							cornerRadius: 25-padding
						))
						.transition(.scale)
						.animation(.spring, value: ASmanager.albumArt)
				}
			}
		}
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
