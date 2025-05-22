//
//  HelpView.swift
//  AirAP
//
//  Created by neon443 on 22/05/2025.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
		List {
			Section("Does not appear in AirPlay Picker") {
				Text("1. Open AirPlay picker on other device")
				Text("2. Toggle server on and off")
			}
		}
    }
}

#Preview {
    HelpView()
}
