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
				SliderDetailView(
					value: $ASmanager.settings.delay,
					range: -2...2,
					defaultValue: 0,
					step: 0.25,
					title: "Delay",
					minLabel: "-2s",
					maxLabel: " 2s",
					disabled: $ASmanager.running
				)
				.onChange(of: ASmanager.settings.delay) { _ in
					ASmanager.settings.saveSettings()
				}
				
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
					SliderDetailView(
						value: $ASmanager.settings.bgOpacity,
						range: 0...1,
						defaultValue: 0.8,
						step: 0.05,
						title: "Opacity",
						minLabel: "0%",
						maxLabel: "100%",
						disabled: Binding(get: {
							!ASmanager.settings.showBg
						}, set: { ASmanager.settings.showBg = $0 })
					)
					.onChange(of: ASmanager.settings.bgOpacity) { _ in
						ASmanager.settings.saveSettings()
					}

					SliderDetailView(
						value: $ASmanager.settings.bgBlur,
						range: 0...100,
						defaultValue: 75,
						step: 5,
						title: "Blur",
						minLabel: "0" ,
						maxLabel: "100",
						disabled: Binding(get: {
							!ASmanager.settings.showBg
						}, set: { ASmanager.settings.showBg = $0 })
					)
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
