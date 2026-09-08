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
		
		self.sampleRate = MetadataChunkView(title: "sample rate", alignment: .center)
		self.bitDepth = MetadataChunkView(title: "bit depth", alignment: .center)
		self.channels = MetadataChunkView(title: "channels", alignment: .center)
		self.qualStack = UIStackView(arrangedSubviews: [sampleRate, bitDepth, channels])
		
		var effect: UIVisualEffect
		if #available(iOS 19, *) {
			let glassEffect = UIGlassEffect()
			glassEffect.isInteractive = true
			effect = glassEffect
		} else {
			effect = UIBlurEffect(style: .systemThinMaterialSafe)
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
		self.layer.cornerRadius = 24
		
		stack.axis = .vertical
		stack.spacing = 8
		stack.distribution = .equalSpacing
		stack.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
		stack.isLayoutMarginsRelativeArrangement = true
		
		title.font = UIFont.preferredFont(forTextStyle: .title1, andWeight: .bold)
		title.layer.shadowColor = UIColor(named: "background")?.cgColor
		title.layer.shadowOpacity = 0.5
		title.layer.shadowRadius = 3
		
		qualStack.axis = .horizontal
		qualStack.distribution = .equalSpacing
		qualStack.alignment = .lastBaseline
		qualStack.layoutMargins = .init(top: 8, left: 32, bottom: 8, right: 32)
		qualStack.isLayoutMarginsRelativeArrangement = true
		
		let container = UIStackView(arrangedSubviews: [stack, qualStack])
		container.axis = .vertical
		container.spacing = 0
		
		contentView.addSubview(container)
		container.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			container.topAnchor.constraint(equalTo: contentView.topAnchor),
			container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
	
	func refreshUI() {
		if !asManager.settings.showMetadata && !asManager.settings.showAudioQuality {
			self.layer.opacity = 0
			return
		}
		self.layer.opacity = 1
		
		setTrackInfoVisible(asManager.settings.showMetadata)
		setQualityInfoVisibel(asManager.settings.showAudioQuality)
		
		title.text = asManager.title ?? "Not Playing"
		title.textColor = .foreground.withAlphaComponent(asManager.title == nil ? 0.5 : 1)
		album.setContent(to: asManager.album ?? "——")
		artist.setContent(to: asManager.artist ?? "——")
		
		sampleRate.setContent(to: "\(asManager.airstream!.sampleRate)")
		bitDepth.setContent(to: "\(asManager.airstream!.bitsPerChannel)")
		channels.setContent(to: "\(asManager.airstream!.channelsPerFrame)")
	}
	
	func setTrackInfoVisible(_ visible: Bool) {
		stack.isHidden = !visible
	}
	
	func setQualityInfoVisibel(_ visible: Bool) {
		qualStack.isHidden = !visible
	}
}
