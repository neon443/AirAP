//
//  NowPlayingViewController.swift
//  AirAP
//
//  Created by neon443 on 31/08/2026.
//

import Foundation
import UIKit

class NowPlayingViewController: UIViewController {
	var asManager: AirstreamManager
	var npStack: NowPlayingStackView
	
	init(asManager: AirstreamManager) {
		self.asManager = asManager
		self.npStack = .init(asManager: asManager)
		super.init(nibName: nil, bundle: nil)
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.addSubview(npStack)
		npStack.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			npStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
			npStack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			npStack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			npStack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
		])
	}
}
