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
		NavigationStack {
			List {
				TextField("AirPlay Server Name", text: $ASmanager.name)
					.textFieldStyle(RoundedBorderTextFieldStyle())
				Text(
					"Server: \(ASmanager.running ? "Running" : "Not Running")"
				)
				.contentTransition(.numericText())
				.foregroundStyle(ASmanager.running ? .green : .red)
//				.animation(.default, value: ASmanager.running)
			}
			Spacer()
			Button() {
				ASmanager.startStop()
			} label: {
				Text(ASmanager.running ? "Stop" : "Start")
					.contentTransition(.numericText())
					.bold()
					.monospaced()
					.font(.title)
			}
			.buttonStyle(BorderedProminentButtonStyle())
			.sensoryFeedback(.impact(weight: .heavy, intensity: 1.0), trigger: ASmanager.running)
			.padding(.bottom)
		}
    }
}

#Preview {
    ContentView()
}
