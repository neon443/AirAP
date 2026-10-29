//
//  NPSlider.swift
//  AirAP
//
//  Created by neon443 on 29/10/2026.
//

import Foundation
import UIKit

@available(iOS 13, *)
class NPSlider: UIView {
	var value: Float
	var valueFrac: Float {
		return (value - minimumValue) / (maximumValue - minimumValue)
	}
	
	var minimumValue: Float
	var maximumValue: Float
	
	private var trackBackground: UIView
	private var trackForeground: UIView
	
	private var foregroundWidthConstraint: NSLayoutConstraint!
	private var bgHeightConstraint: NSLayoutConstraint!
	private var fgHeightConstraint: NSLayoutConstraint!
	
	
	init() {
		self.value = 0.5
		self.minimumValue = 0.0
		self.maximumValue = 1.0
		
		trackForeground = UIView()
		trackBackground = UIView()
		
		super.init(frame: .zero)
		
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setValue(value: Float, animated: Bool) {
		let newValue = min(maximumValue, max(minimumValue, value))
		self.value = newValue
		
		foregroundWidthConstraint.isActive = false
		foregroundWidthConstraint = trackForeground.widthAnchor.constraint(equalTo: trackBackground.widthAnchor, multiplier: CGFloat(valueFrac))
		foregroundWidthConstraint.isActive = true
		
		if animated {
			UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut]) {
				self.layoutIfNeeded()
			}
		} else {
			layoutIfNeeded()
		}
		
		refreshUI()
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		fgHeightConstraint.isActive = false
		bgHeightConstraint.isActive = false
		fgHeightConstraint = trackForeground.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -20)
		bgHeightConstraint = trackBackground.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -20)
		fgHeightConstraint.isActive = true
		bgHeightConstraint.isActive = true

		
		
		UIView.animate(withDuration: 0.1, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut]) {
			self.trackBackground.layer.cornerRadius = 10
			self.trackForeground.layer.cornerRadius = 10
			self.layoutIfNeeded()
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		fgHeightConstraint.isActive = false
		bgHeightConstraint.isActive = false
		fgHeightConstraint = trackForeground.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -30)
		bgHeightConstraint = trackBackground.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -30)
		fgHeightConstraint.isActive = true
		bgHeightConstraint.isActive = true
		
		
		UIView.animate(withDuration: 0.1, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut]) {
			self.trackBackground.layer.cornerRadius = 5
			self.trackForeground.layer.cornerRadius = 5
			self.layoutIfNeeded()
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		print(touches.first!.location(in: trackBackground))
		guard let touch = touches.first else { return }
		let loc = touch.location(in: self)
		print(loc.x - touch.previousLocation(in: trackBackground).x)
		
		let diff = loc.x - touch.previousLocation(in: trackBackground).x
		let percentDiff = diff / trackBackground.frame.width
		print(self.valueFrac, diff, percentDiff)
		let newValue = self.valueFrac + Float(percentDiff)
		print(newValue)
		
		if newValue < 0 {
			
		} else if newValue > 1 {
			
		}
		
		setValue(value: newValue, animated: true)
	}
	
	func setup() {
		trackForeground.backgroundColor = .red
		trackBackground.backgroundColor = .gray.withAlphaComponent(0.5)
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
		
		
		fgHeightConstraint = trackForeground.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -30)
		bgHeightConstraint = trackBackground.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -30)
		fgHeightConstraint.isActive = true
		bgHeightConstraint.isActive = true
		trackForeground.frame.size.height = 10
		trackBackground.frame.size.height = 10
		
		foregroundWidthConstraint = trackForeground.widthAnchor.constraint(equalTo: trackBackground.widthAnchor, multiplier: CGFloat(valueFrac))
		foregroundWidthConstraint.isActive = true
		
		bringSubviewToFront(trackForeground)
		
		trackBackground.layer.cornerRadius = 5
		trackForeground.layer.cornerRadius = 5
	}
	
	func refreshUI() {
		self.foregroundWidthConstraint.isActive = false
		self.foregroundWidthConstraint = self.trackForeground.widthAnchor.constraint(equalTo: self.trackBackground.widthAnchor, multiplier: CGFloat(self.valueFrac))
		self.foregroundWidthConstraint.isActive = true
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
	stack.layoutMargins = UIEdgeInsets(top: 8, left: 50, bottom: 8, right: 100)
	stack.isLayoutMarginsRelativeArrangement = true
	
	DispatchQueue.main.asyncAfter(deadline: .now()+1) {
		y.setValue(value: 0.8, animated: true)
		stack.layoutMargins = UIEdgeInsets(top: 8, left: 50, bottom: 8, right: 80)
	}
	
	return stack
}
