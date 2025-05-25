//
//  SettingsView.swift
//  AirAP
//
//  Created by neon443 on 20/05/2025.
//

import SwiftUI

struct SettingsView: View {
	@ObservedObject var ASmanager: AirstreamManager
	@ObservedObject var settingsModel: AAPSettingsModel
	
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
					Toggle("Show blurred album art as background", isOn: $settingsModel.showBg)
						.onChange(of: settingsModel.showBg) {
							print("show bg is toggled \(settingsModel.showBg)")
							settingsModel.saveSettings()
						}
					Slider(value: $settingsModel.bgOpacity, in: 0...1)
						.onChange(of: settingsModel.bgOpacity) {
							print("changed bgopacity \(settingsModel.bgOpacity)")
							settingsModel.saveSettings()
						}
					Slider(value: $settingsModel.bgBlur, in: 0...100, step: 10)
						.onChange(of: settingsModel.bgBlur) {
							print("modified the blur \(settingsModel.bgBlur)")
							settingsModel.saveSettings()
						}
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
		settingsModel: AAPSettingsModel()
	)
}
