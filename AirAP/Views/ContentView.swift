//
//  ContentView.swift
//  AirAP
//
//  Created by neon443 on 16/05/2025.
//

import SwiftUI
import Airstream

struct ContentView: View {
	@StateObject var ASmanager = AirstreamManager()
	@StateObject var settingsModel = AAPSettingsModel()
	
	var body: some View {
		TabView {
			NowPlaying(
				ASmanager: ASmanager,
				settingsModel: settingsModel
			)
				.tabItem {
					Label("Now Playing", systemImage: "play.fill")
				}
			HelpView()
				.tabItem {
					Label("Help", systemImage: "questionmark.app")
				}
			SettingsView(
				ASmanager: ASmanager,
				settingsModel: settingsModel
			)
				.tabItem {
					Label("Settings", systemImage: "gear")
				}
		}
	}
}

#Preview {
    ContentView()
}
