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
			ZStack(alignment: .center) {
				RoundedRectangle(cornerRadius: 10)
					.foregroundStyle(
						ASmanager.running ? .red : .green
					)
				Text(ASmanager.running ? "Stop" : "Start")
					.contentTransition(.numericText())
					.bold()
					.monospaced()
					.font(.title)
					.padding(5)
			}
			.fixedSize()
		}
		.buttonStyle(PlainButtonStyle())
		.sensoryFeedback(.impact(weight: .heavy, intensity: 1.0), trigger: ASmanager.running)
		.padding(.bottom, 5)
    }
}

#Preview {
    StartStopButton(ASmanager: AirstreamManager())
}
