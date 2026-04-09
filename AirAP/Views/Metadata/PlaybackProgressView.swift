//
//  PlaybackProgressView.swift
//  AirAP
//
//  Created by neon443 on 26/05/2025.
//

import SwiftUI

@available(iOS 14, *)
struct PlaybackProgressView: View {
	@ObservedObject var ASmanager: AirstreamManager
	
    var body: some View {
		
    }
}

@available(iOS 14, *)
#Preview {
    PlaybackProgressView(
		ASmanager: AirstreamManager()
	)
}
