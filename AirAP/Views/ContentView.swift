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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
			Text(ASmanager.airstream?.name ?? "nnone")
			Text("\(ASmanager.airstream?.running ?? false)")
			Text("\(ASmanager.airstream?.volume ?? -1)")
			Text("\(ASmanager.airstream?.metadata ?? [:])")
			if let coverart = ASmanager.coverArt {
				Image(uiImage: coverart)
			}
        }
		.onTapGesture {
			hey = UUID()
		}
		.id(hey)
        .padding()
    }
}

#Preview {
    ContentView()
}
