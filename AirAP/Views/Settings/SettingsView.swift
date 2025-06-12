//
//  SettingsView.swift
//  AirAP
//
//  Created by neon443 on 20/05/2025.
//

import SwiftUI

struct SettingsView: View {
	@ObservedObject var ASmanager: AirstreamManager
	
	var body: some View {
		VStack {
			Form {
				Section(
					header: Text("server"),
					footer: Text("Changing the name will restart the AirPlay server")
				) {
					HStack {
						TextField("AirPlay Server Name", text: $ASmanager.settings.name)
							.textFieldStyle(RoundedBorderTextFieldStyle())
						Button() {
							ASmanager.settings.saveSettings()
							ASmanager.startStop()
							ASmanager.startStop()
						} label: {
							Image(systemName: "checkmark.circle.fill")
								.resizable()
								.scaledToFit()
								.frame(width: 40)
						}
					}
				}
				Section(
					header: Text("background")
				) {
					Toggle("Show blurred album art as background", isOn: $ASmanager.settings.showBg)
						.onChange(of: ASmanager.settings.showBg) { _ in
							ASmanager.settings.saveSettings()
						}
					VStack(alignment: .center) {
						HStack {
							Text("Opacity")
							Spacer()
							Text("\(Int(ASmanager.settings.bgOpacity*100))%")
								.font(.title3)
								.bold()
								.modifier(monospacedIfAv())
						}
						HStack {
							Text("0%")
								.modifier(monospacedIfAv())
							Slider(value: $ASmanager.settings.bgOpacity, in: 0...1, step: 0.05)
								.onChange(of: ASmanager.settings.bgOpacity) { _ in
									ASmanager.settings.saveSettings()
								}
								.disabled(!ASmanager.settings.showBg)
							Text("100%")
								.modifier(monospacedIfAv())
						}
					}
					VStack(alignment: .center) {
						HStack {
							Text("Blur")
							Spacer()
							Text("\(Int(ASmanager.settings.bgBlur))")
								.font(.title3)
								.bold()
								.modifier(monospacedIfAv())
						}
						HStack {
							Text("0 ")
								.modifier(monospacedIfAv())
							Slider(value: $ASmanager.settings.bgBlur, in: 0...100, step: 5)
								.onChange(of: ASmanager.settings.bgBlur) { _ in
									ASmanager.settings.saveSettings()
								}
								.disabled(!ASmanager.settings.showBg)
							Text("100")
								.modifier(monospacedIfAv())
						}
					}
				}
				Section(
					header: Text("metadata")
				) {
					Toggle("Show metadata", isOn: $ASmanager.settings.showMetadata)
						.onChange(of: ASmanager.settings.showMetadata) { _ in
							ASmanager.settings.showAudioQuality = false
							ASmanager.settings.saveSettings()
						}
					Toggle("Show audio quality information", isOn: $ASmanager.settings.showAudioQuality)
						.onChange(of: ASmanager.settings.showAudioQuality) { _ in
							ASmanager.settings.saveSettings()
						}
						.disabled(!ASmanager.settings.showMetadata)
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
