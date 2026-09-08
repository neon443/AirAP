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
	var startStopButton: ServerStateButton
	var bgBlur: UIVisualEffectView
	var bgImage: UIImageView
	
	init(asManager: AirstreamManager) {
		self.asManager = asManager
		self.npStack = .init(asManager: asManager)
		self.startStopButton = ServerStateButton(asManager: asManager)
		self.bgBlur = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialSafe))
		self.bgImage = UIImageView()
		super.init(nibName: nil, bundle: nil)
		refreshUI()
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func refreshUI() {
		bgImage.image = asManager.albumArt
		let showBg = asManager.settings.showBg
		bgImage.alpha = showBg ? CGFloat(asManager.settings.bgOpacity/100) : 0
		
		bgBlur.effect = UIBlurEffect(style: asManager.settings.bgBlur.uiBlurEffectStyle)
		
		startStopButton.refreshUI()
		npStack.refresUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.refreshUI()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		asManager.didSetAlbumArt = { self.refreshUI() }
		
		self.view.addSubview(bgImage)
		self.view.addSubview(bgBlur)
		self.view.addSubview(npStack)
		self.view.addSubview(startStopButton)
		bgImage.translatesAutoresizingMaskIntoConstraints = false
		bgBlur.translatesAutoresizingMaskIntoConstraints = false
		npStack.translatesAutoresizingMaskIntoConstraints = false
		startStopButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			bgImage.topAnchor.constraint(equalTo: view.topAnchor),
			bgImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			bgImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			bgImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			bgBlur.topAnchor.constraint(equalTo: view.topAnchor),
			bgBlur.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			bgBlur.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			bgBlur.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			npStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			npStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			npStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			npStack.bottomAnchor.constraint(equalTo: startStopButton.topAnchor, constant: -16),
			
			startStopButton.heightAnchor.constraint(equalToConstant: 32),
			startStopButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
			startStopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
		])
	}
}
