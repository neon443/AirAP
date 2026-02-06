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
					header: Text("Server"),
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
					header: Text("Audio"),
					footer: Text("Changes will take effect next time the server is started")
				) {
					SliderDetailView(
						value: $ASmanager.settings.delay,
						valueUnit: "s",
						range: -2...2,
						defaultValue: 0,
						step: 0.25,
						dp: 2,
						title: "Delay",
						minLabel: "-2s",
						maxLabel: " 2s",
						disabled: .constant(false)
					)
					.onChange(of: ASmanager.settings.delay) { _ in
						ASmanager.settings.saveSettings()
					}
				}
				
				Section(
					header: Text("Background")
				) {
					Toggle("Show album art", isOn: $ASmanager.settings.showBg)
						.onChange(of: ASmanager.settings.showBg) { _ in
							ASmanager.settings.saveSettings()
						}
					SliderDetailView(
						value: $ASmanager.settings.bgOpacity,
						valueUnit: "%",
						range: 0...1,
						defaultValue: 0.8,
						step: 0.05,
						dp: 1,
						multiplyUIValueBy: 100,
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
						valueUnit: "",
						range: 0...100,
						defaultValue: 75,
						step: 5,
						dp: 0,
						title: "Blur",
						minLabel: "0 " ,
						maxLabel: "100 ",
						disabled: Binding(get: {
							!ASmanager.settings.showBg
						}, set: { ASmanager.settings.showBg = $0 })
					)
				}
				Section(
					header: Text("Metadata")
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
			.modifier(OverlayIfPossible(alignment: .bottom, overlayContent: {
				StartStopButton(ASmanager: ASmanager)
			}))
		}
	}
}

#Preview {
	SettingsView(
		ASmanager: AirstreamManager()
	)
}
