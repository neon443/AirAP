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
	var body: some View {
		Text(
			"Server: \(ASmanager.running ? "Running" : "Not Running")"
		)
		.contentTransition(.numericText())
		.foregroundStyle(ASmanager.running ? .green : .red)
		TabView {
			NowPlaying(ASmanager: ASmanager)
				.tabItem {
					Label("Now Playing", systemImage: "play.fill")
				}
			SettingsView(ASmanager: ASmanager)
				.tabItem {
					Label("Settings", systemImage: "gear")
				}
		}
	}
}

#Preview {
    ContentView()
}
