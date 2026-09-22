//
//  PlaybackControlsView.swift
//  AirAP
//
//  Created by neon443 on 22/09/2026.
//

import Foundation
import UIKit

class PlaybackControlsView: UIStackView {
	var asManager: AirstreamManager
	
	var position: UISlider
	var volume: UISlider
	
	init(asManager: AirstreamManager) {
		self.asManager = asManager
		
		self.position = UISlider(frame: .zero)
		self.volume = UISlider(frame: .zero)
		
		super.init(frame: .zero)
		
		self.addArrangedSubview(position)
		self.addArrangedSubview(volume)
		
		setup()
		refreshUI()
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		self.axis = .vertical
		self.spacing = .zero
		
		if #available(iOS 26, *) {
			volume.sliderStyle = .thumbless
			position.sliderStyle = .thumbless
		}
		volume.isUserInteractionEnabled = false
		position.isUserInteractionEnabled = false
		
		asManager.updateVolume = { self.volume.setValue($0, animated: true) }
		asManager.updatePosition = { self.position.setValue($0/$1, animated: true) }
	}
	
	func refreshUI() {
//		asManager.updateVolume?(asManager.airstream!.volume)
	}
}
