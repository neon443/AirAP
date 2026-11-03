//
//  NowPlayingStackView.swift
//  AirAP
//
//  Created by neon443 on 31/08/2026.
//

import Foundation
import UIKit

class NowPlayingStackView: UIStackView {
	let albumArtView: AlbumArtView!
	let metadataView: MetadataView!
	
	init() {
		self.albumArtView = AlbumArtView()
		self.metadataView = MetadataView()
		super.init(frame: .zero)
		
		self.spacing = 8
		self.axis = .vertical
		self.distribution = .equalSpacing
		self.addArrangedSubview(self.albumArtView)
		self.addArrangedSubview(self.metadataView)
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func refresUI() {
		albumArtView.refreshUI()
		metadataView.refreshUI()
	}
}
