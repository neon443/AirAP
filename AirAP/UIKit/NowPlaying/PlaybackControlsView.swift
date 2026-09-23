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
	
	var back: UIButton
	var pause: UIButton
	var forawrd: UIButton
	var trackStack: UIStackView
	
	var volume: UISlider
	
	init(asManager: AirstreamManager) {
		self.asManager = asManager
		
		self.position = UISlider(frame: .zero)
		self.volume = UISlider(frame: .zero)
		
		self.back = UIButton(type: .custom)
		self.pause = UIButton(type: .custom)
		self.forawrd = UIButton(type: .custom)
		self.trackStack = UIStackView(arrangedSubviews: [UIView(), back, pause, forawrd, UIView()])
		
		super.init(frame: .zero)
		
		self.addArrangedSubview(position)
		self.addArrangedSubview(trackStack)
		self.addArrangedSubview(volume)
		
		setup()
		refreshUI()
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func backTapped() {
		asManager.airstream?.remote?.nextItem()
	}
	
	@objc func pauseTapped() {
		asManager.airstream?.remote?.playPause()
		
	}
	
	@objc func skipTapped() {
		asManager.airstream?.remote?.previousItem()
	}
	
	func setup() {
		back.setImage(UIImage(named: "backward.fill"), for: .normal)
		forawrd.setImage(UIImage(named: "forward.fill"), for: .normal)
		pause.setImage(UIImage(named: "play.fill"), for: .normal)
		
		back.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
		forawrd.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
		pause.addTarget(self, action: #selector(pauseTapped), for: .touchUpInside)
		
		trackStack.axis = .horizontal
		trackStack.distribution = .equalSpacing
		
		self.axis = .vertical
		self.spacing = .zero
//		self.layoutMargins.top = -8
		self.layoutMargins.left = 8
		self.layoutMargins.right = 8
		self.isLayoutMarginsRelativeArrangement = true
		
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
