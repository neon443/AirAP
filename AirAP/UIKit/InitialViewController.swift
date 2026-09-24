//
//  InitialViewController.swift
//  AirAP
//
//  Created by neon443 on 31/08/2026.
//

import Foundation
import UIKit

class InitialViewController: UITabBarController {
	var asManager: AirstreamManager
	
	init(asManager: AirstreamManager) {
		self.asManager = asManager
		super.init(nibName: nil, bundle: nil)
		
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		let nowView = NowPlayingViewController(asManager: asManager)
		nowView.tabBarItem = .init(title: "Now Playing", image: UIImage(named: "play.fill.mini"), tag: 0)
		
		let helpView = HelpViewController(asManager: asManager)
		helpView.tabBarItem = .init(title: "Help", image: UIImage(named: "questionmark"), tag: 1)
		
		let settingsView = SettingsViewController(asManager: asManager)
		settingsView.tabBarItem = .init(title: "Settings", image: UIImage(named: "gear"), tag: 2)
		
		self.setViewControllers([nowView, helpView, settingsView], animated: false)
	}
}
