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
	
	func setup() {
		trackForeground.backgroundColor = .red
		trackBackground.backgroundColor = .gray.withAlphaComponent(0.5)
		self.addSubview(trackBackground)
		self.addSubview(trackForeground)
		trackForeground.translatesAutoresizingMaskIntoConstraints = false
		trackBackground.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			trackBackground.topAnchor.constraint(equalTo: topAnchor),
			trackBackground.bottomAnchor.constraint(equalTo: bottomAnchor),
			trackBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
			trackBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
			
			trackBackground.leadingAnchor.constraint(equalTo: trackForeground.leadingAnchor),
			
			self.heightAnchor.constraint(equalToConstant: 10),
			trackBackground.heightAnchor.constraint(equalTo: self.heightAnchor),
			trackForeground.heightAnchor.constraint(equalTo: self.heightAnchor)
		])
		
		foregroundWidthConstraint = trackForeground.widthAnchor.constraint(equalTo: trackBackground.widthAnchor, multiplier: CGFloat(value))
		foregroundWidthConstraint.isActive = true
		
		bringSubviewToFront(trackForeground)
		
		layer.cornerRadius = 5
		layer.masksToBounds = true
	}
	
	func refreshUI() {
		foregroundWidthConstraint.isActive = false
		foregroundWidthConstraint = trackForeground.widthAnchor.constraint(equalTo: trackBackground.widthAnchor, multiplier: CGFloat(value))
		foregroundWidthConstraint.isActive = true
	}
	
	func setValue(value: Float, animated: Bool) {
		self.value = value
		refreshUI()
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
	
	DispatchQueue.main.asyncAfter(deadline: .now()+1) {
		y.setValue(value: 0.8, animated: true)
	}
	
	return stack
}
