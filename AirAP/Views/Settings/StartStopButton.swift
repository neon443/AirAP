//
//  StartStopButton.swift
//  AirAP
//
//  Created by neon443 on 20/05/2025.
//

import SwiftUI

struct StartStopButton: View {
	@ObservedObject var ASmanager: AirstreamManager
	
    var body: some View {
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
		.frame(maxWidth: .infinity)
    }
}

#Preview {
    StartStopButton(ASmanager: AirstreamManager())
}
