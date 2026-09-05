//
//  MetadataView.swift
//  AirAP
//
//  Created by neon443 on 31/08/2026.
//

import Foundation
import UIKit

class MetadataView: UIVisualEffectView {
	var asManager: AirstreamManager
	
	var stack: UIStackView
	var title: UILabel
//	var title: MetadataChunkView
	var album: MetadataChunkView
	var artist: MetadataChunkView
	
	var qualStack: UIStackView
	var sampleRate: MetadataChunkView
	var bitDepth: MetadataChunkView
	var channels: MetadataChunkView
	
	init(asManager: AirstreamManager) {
		self.asManager = asManager
		
		self.title = UILabel()
//		self.title = MetadataChunkView(title: "title")
		self.album = MetadataChunkView(title: "album")
		self.artist = MetadataChunkView(title: "artist")
		self.stack = UIStackView(arrangedSubviews: [title, album, artist])
		
		self.sampleRate = MetadataChunkView(title: "sample rate")
		self.bitDepth = MetadataChunkView(title: "bit depth")
		self.channels = MetadataChunkView(title: "channels")
		self.qualStack = UIStackView(arrangedSubviews: [sampleRate, bitDepth, channels])
		
		var effect: UIVisualEffect
		if #available(iOS 19, *) {
			let glassEffect = UIGlassEffect()
			glassEffect.isInteractive = true
			effect = glassEffect
		} else {
			effect = UIBlurEffect(style: .systemThinMaterial)
		}
		super.init(effect: effect)
		
		asManager.didSetMetadata = { self.refreshUI() }
		
		setup()
		
		refreshUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		stack.axis = .vertical
		stack.distribution = .equalSpacing
		stack.layoutMargins = .init(top: 16, left: 8, bottom: 16, right: 8)
		stack.isLayoutMarginsRelativeArrangement = true
		
		title.font = UIFont.preferredFont(forTextStyle: .title2)
		title.layer.shadowColor = UIColor(named: "background")?.cgColor
		title.layer.shadowOpacity = 0.5
		title.layer.shadowRadius = 3
		
		qualStack.axis = .horizontal
		qualStack.distribution = .equalSpacing
		qualStack.alignment = .center
		qualStack.layoutMargins = .init(top: 16, left: 32, bottom: 16, right: 32)
		qualStack.isLayoutMarginsRelativeArrangement = true
		
		sampleRate.alignment = .center
		bitDepth.alignment = .center
		channels.alignment = .center
		
		self.contentView.addSubview(stack)
		self.contentView.addSubview(qualStack)
		stack.translatesAutoresizingMaskIntoConstraints = false
		qualStack.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			stack.topAnchor.constraint(equalTo: self.topAnchor),
			
			qualStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			qualStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			qualStack.topAnchor.constraint(equalTo: stack.bottomAnchor),
			qualStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		])
	}
	
	func refreshUI() {
		album.setContent(to: "hi2")
		artist.setContent(to: "artis")
		sampleRate.setContent(to: "hi")
		bitDepth.setContent(to: "hi2")
		channels.setContent(to: "artis")
		
		title.text = asManager.title ?? "Not Playing"
		title.textColor = .foreground.withAlphaComponent(asManager.title == nil ? 0.5 : 1)
		album.setContent(to: asManager.album)
		artist.setContent(to: asManager.artist)
		
		if asManager.settings.showAudioQuality {
			sampleRate.setContent(to: "\(asManager.airstream!.sampleRate)")
			bitDepth.setContent(to: "\(asManager.airstream!.bitsPerChannel)")
			channels.setContent(to: "\(asManager.airstream!.channelsPerFrame)")
			
		}
	}
}
