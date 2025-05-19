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
	@State var hey = UUID()
    var body: some View {
		NavigationStack {
			List {
				Button("refresh") {
					hey = UUID()
				}
				Button(ASmanager.running ? "Stop" : "Start") {
					ASmanager.startStop()
				}
				Text(ASmanager.airstream?.name ?? "Not Running")
				Text("\(ASmanager.airstream?.running ?? false)")
				Text("\(ASmanager.airstream?.volume ?? -1)")
				Text("\(ASmanager.airstream?.duration)")
				Text("\(ASmanager.airstream?.position)")
				if let coverart = ASmanager.art {
					Image(uiImage: coverart)
				}
			}
			.id(hey)
			.onReceive(ASmanager.objectWillChange) {
				hey = UUID()
			}
		}
    }
}

#Preview {
    ContentView()
}
