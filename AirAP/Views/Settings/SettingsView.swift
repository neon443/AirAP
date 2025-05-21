//
//  SettingsView.swift
//  AirAP
//
//  Created by neon443 on 20/05/2025.
//

import SwiftUI

struct SettingsView: View {
	@StateObject var ASmanager: AirstreamManager
	
	var body: some View {
		VStack {
			Form {
				Section(
					header: Text("server"),
					footer: Text("Restart the AirPlay Server to apply changes")
				) {
					TextField("AirPlay Server Name", text: $ASmanager.name)
						.textFieldStyle(RoundedBorderTextFieldStyle())
				}
			}
			Spacer()
			StartStopButton(ASmanager: ASmanager)
		}
    }
}

#Preview {
	SettingsView(
		ASmanager: AirstreamManager()
	)
}
