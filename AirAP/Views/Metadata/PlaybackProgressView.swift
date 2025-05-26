//
//  PlaybackProgressView.swift
//  AirAP
//
//  Created by neon443 on 26/05/2025.
//

import SwiftUI

struct PlaybackProgressView: View {
	@ObservedObject var ASmanager: AirstreamManager
	@ObservedObject var settingsModel: AAPSettingsModel
	
    var body: some View {
		
    }
}

#Preview {
    PlaybackProgressView(
		ASmanager: AirstreamManager(),
		settingsModel: AAPSettingsModel()
	)
}
