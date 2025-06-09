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
			if geo.size.width > geo.size.height {
				Landscape(
					ASmanager: ASmanager,
					geoSize: geo.size
				)
			} else {
				Portrait(
					ASmanager: ASmanager,
					geoSize: geo.size
				)
			}
		}
	}
}

#Preview {
	NowPlaying(
		ASmanager: AirstreamManager()
	)
}
