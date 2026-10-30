//
//  NPSlider.swift
//  AirAP
//
//  Created by neon443 on 29/10/2026.
//

import Foundation
import UIKit

class NPSlider: UIControl {
	var value: Float
	var valueFrac: Float {
		return (value - minimumValue) / (maximumValue - minimumValue)
	}
	
	var minimumValue: Float
	var maximumValue: Float
	
	private var trackBackground: UIView
	private var trackForeground: UIView
	
	private var foregroundWidthConstraint: NSLayoutConstraint?
	private var bgHeightConstraint: NSLayoutConstraint?
	private var fgHeightConstraint: NSLayoutConstraint?
	
	var initialTouchLocation: CGPoint = .zero
	var initialValue: Float = 0
	
	init() {
		self.value = 0.0
		self.minimumValue = 0.0
		self.maximumValue = 1.0
		
		trackForeground = UIView()
		trackBackground = UIView()
		
		super.init(frame: .zero)
		
		setup()
		refreshUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
//	override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
//		super.sendAction(action, to: target, for: event)
//	}
	
	func setValue(_ value: Float, animated: Bool) {
		let newValue = min(maximumValue, max(minimumValue, value))
		self.value = newValue
		
		foregroundWidthConstraint?.deactivate()
		foregroundWidthConstraint = trackForeground.widthAnchor.constraint(equalTo: trackBackground.widthAnchor, multiplier: CGFloat(valueFrac))
		foregroundWidthConstraint?.activate()
		
		if animated {
			UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut]) {
				self.layoutIfNeeded()
			}
		} else {
			layoutIfNeeded()
		}
		
		refreshUI()
	}

	override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		guard isUserInteractionEnabled else { return false }
		initialTouchLocation = touch.location(in: self)
		initialValue = self.value
		thick()
		return true
	}
	
	override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
		super.endTracking(touch, with: event)
		thin()
		guard let touch,
			  isUserInteractionEnabled else { return }
		handleDrag(touch: touch, animated: true)
	}
	
	override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		guard isUserInteractionEnabled else { return false }
		handleDrag(touch: touch, animated: false)
		return true
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first,
				isUserInteractionEnabled else { return }
		initialTouchLocation = touch.location(in: self)
		initialValue = self.value
		thick()
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		thin()
		guard let touch = touches.first,
			  isUserInteractionEnabled else { return }
		handleDrag(touch: touch, animated: true)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard isUserInteractionEnabled,
			  let touch = touches.first else { return }
		handleDrag(touch: touch, animated: false)
	}

	func thick() {
		fgHeightConstraint?.deactivate()
		bgHeightConstraint?.deactivate()
		fgHeightConstraint = trackForeground.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -22)
		bgHeightConstraint = trackBackground.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -22)
		fgHeightConstraint?.activate()
		bgHeightConstraint?.activate()
		
		UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState, .curveEaseOut]) {
			self.trackBackground.layer.cornerRadius = 10
			self.trackForeground.layer.cornerRadius = 10
			self.layoutIfNeeded()
		}
	}
	
	func thin() {
		fgHeightConstraint?.deactivate()
		bgHeightConstraint?.deactivate()
		fgHeightConstraint = trackForeground.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -33)
		bgHeightConstraint = trackBackground.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -33)
		fgHeightConstraint?.activate()
		bgHeightConstraint?.activate()
		
		UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState, .curveEaseOut]) {
			self.trackBackground.layer.cornerRadius = 3.5
			self.trackForeground.layer.cornerRadius = 3.5
			self.layoutIfNeeded()
		}
	}
	
	func handleDrag(touch: UITouch, animated: Bool) {
		let loc = touch.location(in: self)
		
		let diff = loc.x - initialTouchLocation.x
		let percentDiff = diff / trackBackground.frame.width
		let trackWidth = trackBackground.bounds.width
		
		let valueDelta = Float(diff / trackWidth) * (maximumValue - minimumValue)
		
		setValue(initialValue+valueDelta, animated: false)
		sendActions(for: .valueChanged)
	}
	
	func setup() {
		trackForeground.backgroundColor = UIColor.systemBlue
		trackBackground.backgroundColor = .gray.withAlphaComponent(0.2)
		self.addSubview(trackBackground)
		self.addSubview(trackForeground)
		trackForeground.translatesAutoresizingMaskIntoConstraints = false
		trackBackground.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			trackBackground.centerXAnchor.constraint(equalTo: centerXAnchor),
			trackBackground.centerYAnchor.constraint(equalTo: centerYAnchor),
			
			trackBackground.leadingAnchor.constraint(equalTo: trackForeground.leadingAnchor),
			trackBackground.centerYAnchor.constraint(equalTo: trackForeground.centerYAnchor),
			
			self.heightAnchor.constraint(equalToConstant: 40),

			trackBackground.widthAnchor.constraint(equalTo: self.widthAnchor)
		])
		
		self.endTracking(nil, with: nil)
		
		bringSubviewToFront(trackForeground)
	}
	
	func refreshUI() {
		self.foregroundWidthConstraint?.deactivate()
		self.foregroundWidthConstraint = self.trackForeground.widthAnchor.constraint(equalTo: self.trackBackground.widthAnchor, multiplier: CGFloat(self.valueFrac))
		self.foregroundWidthConstraint?.activate()
	}
}

@available(iOS 26, *)
#Preview {
	let x = UISlider()
	x.value = 0.5
	x.sliderStyle = .thumbless
	
	let y = NPSlider()
	
	let stack = UIStackView(arrangedSubviews: [x, UISlider(), y])
	stack.axis = .vertical
	return stack
}
