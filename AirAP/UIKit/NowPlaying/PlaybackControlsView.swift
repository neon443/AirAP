//
//  PlaybackControlsView.swift
//  AirAP
//
//  Created by neon443 on 22/09/2026.
//

import Foundation
import UIKit
import MediaPlayer

class PlaybackControlsView: UIStackView {
	var position: NPSlider
	var positionStack: UIStackView
	var labelStack: UIStackView
	var positionLabel: UILabel
	var durationLabel: UILabel
	
	var back: UIButton
	var pause: UIButton
	var forawrd: UIButton
	var trackStack: UIStackView
	
	var volume: NPSlider
	var volumeLeading: UIImageView
	var volumeTrailing: UIImageView
	var volumeStack: UIStackView
	var mpVolumeView: MPVolumeView
	
	init() {
		self.position = NPSlider()
		self.positionLabel = UILabel()
		self.durationLabel = UILabel()
		self.labelStack = UIStackView(arrangedSubviews: [positionLabel, UIView(), durationLabel])
		self.positionStack = UIStackView(arrangedSubviews: [position, labelStack])
		
		self.back = UIButton(type: .custom)
		self.pause = UIButton(type: .custom)
		self.forawrd = UIButton(type: .custom)
		self.trackStack = UIStackView(arrangedSubviews: [UIView(), back, UIView(), pause, UIView(), forawrd, UIView()])
		
		self.volume = NPSlider()
		self.volumeLeading = UIImageView(image: UIImage(named: "speaker.fill"))
		self.volumeTrailing = UIImageView(image: UIImage(named: "speaker.wave.3.fill"))
		self.volumeStack = UIStackView(arrangedSubviews: [volumeLeading, volume, volumeTrailing])
		
		self.mpVolumeView = MPVolumeView()
		
		super.init(frame: .zero)
		
		getVolume()
		setup()
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func backTapped() {
		AirAP.asManager.airstream?.remote?.previousItem()
	}
	
	@objc func pauseTapped() {
		AirAP.asManager.airstream?.remote?.playPause()
	}
	
	@objc func skipTapped() {
		AirAP.asManager.airstream?.remote?.nextItem()
	}
	
	func minutesAndSeconds(from input: Float) -> String {
		let mins = (input/60).rounded(.down)
		let sec = Int((((input/60) - mins) * 60).rounded())
		return "\(Int(mins)):\(sec < 10 ? "0" : "")\(sec)"
	}
	
	@objc func updateVolume() {
		(mpVolumeView.subviews.filter { NSStringFromClass($0.classForCoder) == "MPVolumeSlider" }.first as? UISlider)?.setValue(volume.value, animated: false)
	}
	
	@objc func getVolume() {
		guard let vol = (mpVolumeView.subviews.filter { NSStringFromClass($0.classForCoder) == "MPVolumeSlider" }.first as? UISlider)?.value else { return }
		self.volume.setValue(vol, animated: true)
	}
	
	func setup() {
		positionStack.axis = .vertical
		positionStack.spacing = -10
		positionStack.layoutMargins.top = -10
		positionStack.isLayoutMarginsRelativeArrangement = true
		labelStack.axis = .horizontal
		labelStack.distribution = .equalSpacing
		
		positionLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
		durationLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
		positionLabel.textColor = UIColor.foreground.withAlphaComponent(0.75)
		durationLabel.textColor = UIColor.foreground.withAlphaComponent(0.75)
		positionLabel.textAlignment = .left
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
		trackStack.layoutMargins.top = -8
		trackStack.layoutMargins.bottom = -8
		trackStack.isLayoutMarginsRelativeArrangement = true
		
		volumeStack.spacing = 8
		volumeLeading.contentMode = .scaleAspectFit
		volumeTrailing.contentMode = .scaleAspectFit
		
		volume.addTarget(self, action: #selector(updateVolume), for: .valueChanged)
		(mpVolumeView.subviews.filter { NSStringFromClass($0.classForCoder) == "MPVolumeSlider" }.first as? UISlider)?.addTarget(self, action: #selector(getVolume), for: .valueChanged)
		position.isUserInteractionEnabled = false
		
		AirAP.asManager.updatePosition = { position, duration in
			self.positionLabel.text = self.minutesAndSeconds(from: position)
			self.durationLabel.text = self.minutesAndSeconds(from: duration)
			let frac = position/duration
			self.position.setValue(frac.isNaN ? 0 : frac, animated: true)
		}
		AirAP.asManager.updatePauseButton = {
			let animation: CATransition = .init()
			animation.duration = 0.3
			animation.type = .fade
			animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
			self.pause.layer.add(animation, forKey: "changeImageTransition")
			self.pause.setImage(UIImage(named: $0 ? "pause.fill" : "play.fill"), for: .normal)
		}
		AirAP.asManager.updateVolume = { self.volume.setSecondaryValue($0, animated: true) }
		
		self.addArrangedSubview(positionStack)
		self.addArrangedSubview(trackStack)
		self.addArrangedSubview(volumeStack)
		
		self.axis = .vertical
		self.spacing = 4
		self.layoutMargins.left = 8
		self.layoutMargins.right = 8
		self.isLayoutMarginsRelativeArrangement = true
		
		AirAP.asManager.updatePosition?(0,0)
	}
}
