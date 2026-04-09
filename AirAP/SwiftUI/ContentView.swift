//
//  ContentView.swift
//  AirAP
//
//  Created by neon443 on 16/05/2025.
//

import SwiftUI
import Airstream

@available(iOS 13, *)
struct ContentView: View {
	@State var ASmanager = AirstreamManager()
	
	var body: some View {
		if #available(iOS 14, *) {
			TabView {
				NowPlaying(
					ASmanager: ASmanager
				)
				.tabItem {
					Label("Now Playing", systemImage: "play.fill")
				}
				HelpView()
					.tabItem {
						Label("Help", systemImage: "questionmark.app")
					}
				SettingsView(
					ASmanager: ASmanager
				)
				.tabItem {
					Label("Settings", systemImage: "gear")
				}
			}
		} else {
			Text("hi ios 13!")
		}
	}
}

@available(iOS 14, *)
#Preview {
    ContentView()
}
