//
//  MetadataView.swift
//  AirAP
//
//  Created by neon443 on 21/05/2025.
//

import SwiftUI

struct MetadataView: View {
	@ObservedObject var ASmanager: AirstreamManager
    var body: some View {
		Text(ASmanager.title ?? "Not Playing")
			.bold()
			.font(.title)
			.contentTransition(.numericText())
			.multilineTextAlignment(.center)
			.foregroundStyle(
				.primary.opacity(ASmanager.title != nil ? 1 : 0.5)
			)
			.padding(.bottom)
		
		Text("album")
			.foregroundStyle(.gray)
			.font(.subheadline)
		Text(ASmanager.album ?? " ")
			.font(.title3)
			.contentTransition(.numericText())
			.multilineTextAlignment(.center)
			.frame(maxWidth: .infinity)
		
		Text("artist")
			.foregroundStyle(.gray)
			.font(.subheadline)
		Text(ASmanager.artist ?? " ")
			.font(.title3)
			.contentTransition(.numericText())
			.multilineTextAlignment(.center)
			.frame(maxWidth: .infinity)
    }
}

#Preview {
    MetadataView(ASmanager: AirstreamManager())
}
