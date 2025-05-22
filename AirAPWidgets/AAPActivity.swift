//
//  AAPActivity.swift
//  AirAP
//
//  Created by neon443 on 22/05/2025.
//

import SwiftUI
import WidgetKit
import ActivityKit

struct AAPNowPlayingActivityAttributes: ActivityAttributes {
	public struct ContentState: Codable, Hashable {
		var title: String
		var album: String
		var artist: String

		var albumArt: Data?

		var channels: Int
		var sampleRate: Int
		var bitDepth: Int
	}
}

struct AAPActivity: Widget {
	var body: some WidgetConfiguration {
		ActivityConfiguration(for: AAPNowPlayingActivityAttributes.self) { context in
			Text(context.state.title)
		} dynamicIsland: { context in
			DynamicIsland {
				DynamicIslandExpandedRegion(.leading) {
					Text("Live activity")
					Text(context.state.title)
						.bold()
				}
				DynamicIslandExpandedRegion(.trailing) {
					if let albumart = context.state.albumArt {
						if let uiimage = UIImage(data: albumart) {
							Image(uiImage: uiimage)
						}
					}
				}
				DynamicIslandExpandedRegion(.bottom) {
					
				}
			} compactLeading: {
				Image(systemName: "airplayaudio")
					.rotationEffect(.degrees(180))
			} compactTrailing: {
				if let albumart = context.state.albumArt {
					if let uiimage = UIImage(data: albumart) {
						Image(uiImage: uiimage)
					}
				}
			} minimal: {
				if let albumart = context.state.albumArt {
					if let uiimage = UIImage(data: albumart) {
						Image(uiImage: uiimage)
					}
				}
			}
			.keylineTint(.blue)
		}
	}
}

//#Preview("Now Playing", as: .content) {
//    AAPActivity()
//} contentStates: {
//
//}
