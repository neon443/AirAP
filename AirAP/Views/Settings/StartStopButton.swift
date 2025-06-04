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
			UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
		} label: {
			ZStack(alignment: .center) {
				RoundedRectangle(cornerRadius: 10)
					.foregroundStyle(
						ASmanager.running ? .red : .green
					)
				Text(ASmanager.running ? "Stop" : "Start")
					.bold()
					.modifier(contentTransitionIfAv())
					.modifier(monospacedIfAv())
					.font(.title)
					.padding(5)
			}
			.fixedSize()
		}
		.buttonStyle(PlainButtonStyle())
		.padding(.bottom, 5)
    }
}

#Preview {
    StartStopButton(ASmanager: AirstreamManager())
}
