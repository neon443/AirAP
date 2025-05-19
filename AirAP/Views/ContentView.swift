//
//  ContentView.swift
//  AirAP
//
//  Created by neon443 on 16/05/2025.
//

import SwiftUI
import Airstream

struct ContentView: View {
	@StateObject var ASmanager = AirstreamManager()
    var body: some View {
		NavigationStack {
			List {
				Button(ASmanager.running ? "Stop" : "Start") {
					ASmanager.startStop()
				}
				TextField("AirPlay Server Name", text: $ASmanager.name)
				Text("\(ASmanager.airstream?.running ?? false)")
				Text("\(ASmanager.airstream?.volume ?? -1)")
				Text("\(ASmanager.airstream?.duration)")
				Text("\(ASmanager.airstream?.position)")
			}
		}
    }
}

#Preview {
    ContentView()
}
