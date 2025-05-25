//
//  SettingsView.swift
//  AirAP
//
//  Created by neon443 on 20/05/2025.
//

import SwiftUI

struct SettingsView: View {
	@StateObject var ASmanager: AirstreamManager
	@Binding var showBg: Bool
	
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
				Section("appearance") {
					Toggle("Show blurred album art as background", isOn: $showBg)
					Slider(value: .constant(0.5), in: 0...1)
				}
			}
			Spacer()
			StartStopButton(ASmanager: ASmanager)
		}
    }
}

#Preview {
	SettingsView(
		ASmanager: AirstreamManager(),
		showBg: .constant(true)
	)
}
