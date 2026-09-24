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
	var positionStack: UIStackView
	var labelStack: UIStackView
	var positionLabel: UILabel
	var durationLabel: UILabel
	
	var back: UIButton
	var pause: UIButton
	var forawrd: UIButton
	var trackStack: UIStackView
	
	var volume: UISlider
	var volumeLeading: UIImageView
	var volumeTrailing: UIImageView
	var volumeStack: UIStackView
	
	init(asManager: AirstreamManager) {
		self.asManager = asManager
		
		self.position = UISlider(frame: .zero)
		self.positionLabel = UILabel()
		self.durationLabel = UILabel()
		self.labelStack = UIStackView(arrangedSubviews: [positionLabel, UIView(), durationLabel])
		self.positionStack = UIStackView(arrangedSubviews: [position, labelStack])
		
		self.back = UIButton(type: .custom)
		self.pause = UIButton(type: .custom)
		self.forawrd = UIButton(type: .custom)
		self.trackStack = UIStackView(arrangedSubviews: [UIView(), back, pause, forawrd, UIView()])
		
		self.volume = UISlider(frame: .zero)
		self.volumeLeading = UIImageView(image: UIImage(named: "speaker.fill"))
		self.volumeTrailing = UIImageView(image: UIImage(named: "speaker.wave.3.fill"))
		self.volumeStack = UIStackView(arrangedSubviews: [volumeLeading, volume, volumeTrailing])
		
		super.init(frame: .zero)
		
		setup()
		refreshUI()
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func backTapped() {
		asManager.airstream?.remote?.previousItem()
	}
	
	@objc func pauseTapped() {
		asManager.airstream?.remote?.playPause()
		
	}
	
	@objc func skipTapped() {
		asManager.airstream?.remote?.nextItem()
	}
	
	func minutesAndSeconds(from input: Float) -> String {
		let mins = (input/60).rounded(.down)
		let sec = Int((((input/60) - mins) * 60).rounded())
		return "\(Int(mins)):\(sec < 10 ? "0" : "")\(sec)"
	}
	
	func setup() {
		positionStack.axis = .vertical
		positionStack.spacing = 0
		labelStack.axis = .horizontal
		labelStack.distribution = .equalSpacing
		
		positionLabel.textColor = .gray
		positionLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
		positionLabel.textAlignment = .left
		durationLabel.textColor = .gray
		durationLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
		durationLabel.textAlignment = .right
		
		back.setImage(UIImage(named: "backward.fill"), for: .normal)
		forawrd.setImage(UIImage(named: "forward.fill"), for: .normal)
		pause.setImage(UIImage(named: "play.fill"), for: .normal)
		
		back.imageView?.contentMode = .scaleAspectFit
		forawrd.imageView?.contentMode = .scaleAspectFit
		pause.imageView?.contentMode = .scaleAspectFit
		
		back.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
		forawrd.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
		pause.addTarget(self, action: #selector(pauseTapped), for: .touchUpInside)
		
		trackStack.axis = .horizontal
		trackStack.distribution = .fillEqually
		trackStack.layoutMargins.bottom = 8
		trackStack.isLayoutMarginsRelativeArrangement = true
		
		volumeStack.spacing = 8
		volumeLeading.contentMode = .scaleAspectFit
		volumeTrailing.contentMode = .scaleAspectFit
		
		if #available(iOS 26, *) {
			volume.sliderStyle = .thumbless
			position.sliderStyle = .thumbless
		}
		volume.isUserInteractionEnabled = false
		position.isUserInteractionEnabled = false
		
		asManager.updateVolume = { self.volume.setValue($0, animated: true) }
		asManager.updatePosition = { position, duration in
			self.positionLabel.text = self.minutesAndSeconds(from: position)
			self.durationLabel.text = self.minutesAndSeconds(from: duration)
			self.position.setValue(position/duration, animated: true)
		}
		
		self.addArrangedSubview(positionStack)
		self.addArrangedSubview(trackStack)
		self.addArrangedSubview(volumeStack)
		
		self.axis = .vertical
		self.spacing = 4
		self.layoutMargins.left = 8
		self.layoutMargins.right = 8
		self.isLayoutMarginsRelativeArrangement = true
	}
	
	func refreshUI() {
//		asManager.updateVolume?(asManager.airstream!.volume)
	}
}
