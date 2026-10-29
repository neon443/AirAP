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
	
	private var trackBackground: UIView
	private var trackForeground: UIView
	
	private var foregroundWidthConstraint: NSLayoutConstraint!
	private var bgHeightConstraint: NSLayoutConstraint!
	private var fgHeightConstraint: NSLayoutConstraint!
	
	init() {
		self.value = 0.5
		
		trackForeground = UIView()
		trackBackground = UIView()
		
		super.init(frame: .zero)
		
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setValue(value: Float, animated: Bool) {
		self.value = value
		refreshUI()
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		fgHeightConstraint.isActive = false
		bgHeightConstraint.isActive = false
		fgHeightConstraint = trackForeground.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -20)
		bgHeightConstraint = trackBackground.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -20)
		fgHeightConstraint.isActive = true
		bgHeightConstraint.isActive = true

		
		trackBackground.layer.cornerRadius = 10
		trackForeground.layer.cornerRadius = 10
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		fgHeightConstraint.isActive = false
		bgHeightConstraint.isActive = false
		fgHeightConstraint = trackForeground.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -30)
		bgHeightConstraint = trackBackground.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -30)
		fgHeightConstraint.isActive = true
		bgHeightConstraint.isActive = true
		
		trackBackground.layer.cornerRadius = 5
		trackForeground.layer.cornerRadius = 5
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		print(touches.first!.location(in: trackBackground))
		guard let touch = touches.first else { return }
		let loc = touch.location(in: self)
		print(loc.x - touch.previousLocation(in: trackBackground).x)
		
		let diff = loc.x - touch.previousLocation(in: trackBackground).x
		let percentDiff = diff / trackBackground.frame.width
		print(self.value, diff, percentDiff)
		let newValue = self.value + Float(percentDiff)
		setValue(value: min(
				1,
				max(0, newValue)
			), animated: true
		)
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
		
		foregroundWidthConstraint = trackForeground.widthAnchor.constraint(equalTo: trackBackground.widthAnchor, multiplier: CGFloat(value))
		foregroundWidthConstraint.isActive = true
		
		bringSubviewToFront(trackForeground)
		
		trackBackground.layer.cornerRadius = 5
		trackForeground.layer.cornerRadius = 5
	}
	
	func refreshUI() {
		self.foregroundWidthConstraint.isActive = false
		self.foregroundWidthConstraint = self.trackForeground.widthAnchor.constraint(equalTo: self.trackBackground.widthAnchor, multiplier: CGFloat(self.value))
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
	}
	
	return stack
}
