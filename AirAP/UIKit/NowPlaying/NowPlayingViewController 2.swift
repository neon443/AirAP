//
//  NowPlayingViewController 2.swift
//  AirAP
//
//  Created by neon443 on 31/08/2026.
//


class NowPlayingViewController: UIStackView {
	var asManager: AirstreamManager
	
	init(asManager: AirstreamManager) {
		self.asManager = asManager
		super.init(frame: .zero)
		self.axis = .vertical
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewdidloa
}