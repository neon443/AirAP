//
//  NowPlayingStackView.swift
//  AirAP
//
//  Created by neon443 on 31/08/2026.
//

import Foundation
import UIKit

class NowPlayingStackView: UIStackView {
	var asManager: AirstreamManager
	let albumArtView: AlbumArtView!
	let metadataView: MetadataView!
	
	init(asManager: AirstreamManager) {
		self.asManager = asManager
		self.albumArtView = AlbumArtView(asManager: asManager)
		self.metadataView = MetadataView(asManager: asManager)
		super.init(frame: .zero)
		
		self.addArrangedSubview(self.albumArtView)
		self.addArrangedSubview(self.metadataView)
		self.axis = .vertical
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
