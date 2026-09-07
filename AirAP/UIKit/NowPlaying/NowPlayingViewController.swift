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
	
	init(asManager: AirstreamManager) {
		self.asManager = asManager
		self.npStack = .init(asManager: asManager)
		self.startStopButton = ServerStateButton(asManager: asManager)
		super.init(nibName: nil, bundle: nil)
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		npStack.refresUI()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.addSubview(npStack)
		self.view.addSubview(startStopButton)
		npStack.translatesAutoresizingMaskIntoConstraints = false
		startStopButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
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
