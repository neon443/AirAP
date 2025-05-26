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
				Section("background") {
					Toggle("Show blurred album art as background", isOn: $settingsModel.showBg)
						.onChange(of: settingsModel.showBg) {
							settingsModel.saveSettings()
						}
					VStack(alignment: .center) {
						HStack {
							Text("Opacity")
							Spacer()
							Text("\(Int(settingsModel.bgOpacity*100))%")
								.monospaced()
								.bold()
						}
						HStack {
							Text("0%")
								.monospaced()
								.bold()
							Slider(value: $settingsModel.bgOpacity, in: 0...1, step: 0.05)
								.onChange(of: settingsModel.bgOpacity) {
									settingsModel.saveSettings()
								}
								.disabled(!settingsModel.showBg)
							Text("100%")
								.monospaced()
						}
					}
					VStack(alignment: .center) {
						HStack {
							Text("Blur")
							Spacer()
							Text("\(Int(settingsModel.bgBlur))")
								.monospaced()
						}
						HStack {
							Text("0 ")
								.monospaced()
							Slider(value: $settingsModel.bgBlur, in: 0...100, step: 5)
								.onChange(of: settingsModel.bgBlur) {
									settingsModel.saveSettings()
								}
								.disabled(!settingsModel.showBg)
							Text("100")
								.monospaced()
						}
					}
				}
				Section("metadata") {
					Toggle("Show metadata", isOn: $settingsModel.showMetadata)
						.onChange(of: settingsModel.showMetadata) { newVal, _ in
							settingsModel.showAudioQuality = false
							settingsModel.saveSettings()
						}
					Toggle("Show audio quality information", isOn: $settingsModel.showAudioQuality)
						.onChange(of: settingsModel.showAudioQuality) {
							settingsModel.saveSettings()
						}
						.disabled(!settingsModel.showMetadata)
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
