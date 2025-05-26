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
	@ObservedObject var settingsModel: AAPSettingsModel
	
	var body: some View {
		GeometryReader { geo in
			if geo.size.width > geo.size.height {
				Landscape(
					ASmanager: ASmanager,
					settingsModel: settingsModel,
					geoSize: geo.size
				)
			} else {
				Portrait(
					ASmanager: ASmanager,
					settingsModel: settingsModel,
					geoSize: geo.size
				)
			}
		}
	}
}

#Preview {
	NowPlaying(
		ASmanager: AirstreamManager(),
		settingsModel: AAPSettingsModel()
	)
}
