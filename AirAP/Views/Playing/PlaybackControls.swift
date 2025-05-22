//
//  PlaybackControls.swift
//  AirAP
//
//  Created by neon443 on 21/05/2025.
//

import SwiftUI

struct PlaybackControls: View {
	@ObservedObject var ASmanager: AirstreamManager
	
	var body: some View {
		HStack {
			Spacer()
			Button() {
				ASmanager.airstream?.remote?.previousItem()
			} label: {
				Image(systemName: "backward.fill")
					.resizable()
					.scaledToFit()
			}
			.frame(width: 60)
			
			Button() {
				ASmanager.airstream?.remote?.playPause()
			} label: {
				Image(systemName: "play.fill")
					.resizable()
					.scaledToFit()
			}
			.frame(width: 75)
			.padding()
			
			Button() {
				ASmanager.airstream?.remote?.nextItem()
			} label: {
				Image(systemName: "forward.fill")
					.resizable()
					.scaledToFit()
			}
			.frame(width: 60)
			Spacer()
		}
		.disabled(!ASmanager.canControl)
//		.opacity(ASmanager.canControl ? 1.0 : 0.5)
	}
}

#Preview {
	PlaybackControls(
		ASmanager: AirstreamManager()
	)
}
