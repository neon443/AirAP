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
	var sampleRate: MetadataAudioChunk
	var bitDepth: MetadataAudioChunk
	var channels: MetadataAudioChunk
	
	var playbackControls: PlaybackControlsView
	
	init(asManager: AirstreamManager) {
		self.asManager = asManager
		
		self.title = UILabel()
		self.album = MetadataChunkView(image: UIImage(named: "square.stack"))
		self.artist = MetadataChunkView(image: UIImage(named: "music.microphone"))
		self.stack = UIStackView(arrangedSubviews: [title, album, artist])
		
		self.sampleRate = MetadataAudioChunk(type: .sampleRate)
		self.bitDepth = MetadataAudioChunk(type: .bitDepth)
		self.channels = MetadataAudioChunk(type: .channels)
		self.qualStack = UIStackView(arrangedSubviews: [sampleRate, bitDepth, channels])
		
		var effect: UIVisualEffect
		effect = UIBlurEffect(style: .systemUltraThinMaterialSafe)
#if compiler(>=6.2)
		if #available(iOS 19, *) {
			let glassEffect = UIGlassEffect(style: .clear)
			glassEffect.isInteractive = true
			effect = glassEffect
		}
#endif
		
		self.playbackControls = PlaybackControlsView(asManager: asManager)
		
		super.init(effect: effect)
		
		asManager.didSetMetadata = { self.refreshUI() }
		
		setup()
		refreshUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setTrackInfoVisible(_ visible: Bool) {
		stack.isHidden = !visible
	}
	
	func setQualityInfoVisibel(_ visible: Bool) {
		qualStack.isHidden = !visible
	}
	
	func setup() {
		self.layer.masksToBounds = true
		self.layer.cornerRadius = 24
		if #available(iOS 13, *) {
			self.layer.cornerCurve = .continuous
		}
		
		album.axis = .horizontal
		album.spacing = 4
		album.addArrangedSubview(UIView())
		artist.axis = .horizontal
		artist.spacing = 4
		artist.addArrangedSubview(UIView())
		
		stack.axis = .vertical
		stack.spacing = 8
		stack.distribution = .equalSpacing
		
		title.font = UIFont.preferredFont(forTextStyle: .title1, andWeight: .bold)
		
		qualStack.axis = .horizontal
		qualStack.distribution = .equalSpacing
		qualStack.alignment = .lastBaseline
		qualStack.layoutMargins = .init(top: 8, left: 32, bottom: 8, right: 32)
		qualStack.isLayoutMarginsRelativeArrangement = true
		
		let container = UIStackView(arrangedSubviews: [stack, qualStack, playbackControls])
		container.axis = .vertical
		container.spacing = 4
		container.layoutMargins = .init(top: 8, left: 8, bottom: 2, right: 8)
		container.isLayoutMarginsRelativeArrangement = true
		
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
		
		let animation: CATransition = .init()
		animation.duration = 0.3
		animation.type = .fade
		animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		title.layer.add(animation, forKey: "changeTextTransition")
		title.text = asManager.title ?? "Not Playing"
		title.textColor = UIColor.foreground.withAlphaComponent(asManager.title == nil ? 0.5 : 1)
		
		album.setContent(to: asManager.album ?? "——")
		artist.setContent(to: asManager.artist ?? "——")
		
		sampleRate.setContent(to: "\(asManager.airstream!.sampleRate)")
		bitDepth.setContent(to: "\(asManager.airstream!.bitsPerChannel)")
		channels.setContent(to: "\(asManager.airstream!.channelsPerFrame)")
	}
}
