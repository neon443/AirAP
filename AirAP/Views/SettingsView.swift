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
		Form {
			Section("server") {
				TextField("AirPlay Server Name", text: $ASmanager.name)
					.textFieldStyle(RoundedBorderTextFieldStyle())
			}
		}
    }
}

#Preview {
	SettingsView(
		ASmanager: AirstreamManager()
	)
}
