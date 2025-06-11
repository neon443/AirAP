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
		if #available(iOS 19, *) {
			Button() {
				ASmanager.startStop()
				UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
			} label: {
				Text(ASmanager.running ? "Stop" : "Start")
					.bold()
					.foregroundStyle(.black)
//					.modifier(contentTransitionIfAv())
					.modifier(monospacedIfAv())
					.font(.title)
					.padding(5)
			}
//			.glassEffect(.regular)
			.glassEffect(.regular.interactive().tint(ASmanager.running ? .red : .green))
			.padding(.bottom, 5)
		} else {
			Button() {
				ASmanager.startStop()
				UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
			} label: {
				ZStack(alignment: .center) {
					RoundedRectangle(cornerRadius: 10)
						.modifier(foregroundColorStyle(
							ASmanager.running ? .red : .green
						))
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
}

#Preview {
	ZStack {
		VStack {
			ForEach(0..<100) { _ in
				Rectangle()
					.foregroundColor(Color(
						red: Double.random(in: 0...1),
						green: Double.random(in: 0...1),
						blue: Double.random(in: 0...1))
					)
			}
		}
		StartStopButton(ASmanager: AirstreamManager())
			.scaleEffect(4)
	}
}
