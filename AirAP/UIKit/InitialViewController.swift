//
//  InitialViewController.swift
//  AirAP
//
//  Created by neon443 on 31/08/2026.
//

import Foundation
import UIKit
import SwiftUI

class InitialViewController: UITabBarController {
	func setupTabs(with asManager: AirstreamManager) {
		let nowView = NowPlayingViewController(asManager: asManager)
		nowView.tabBarItem = .init(title: "Now Playing", image: UIImage(systemName: "play.fill"), tag: 0)
		
		let helpView = HelpViewController()
		helpView.tabBarItem = .init(title: "Help", image: UIImage(systemName: "questionmark.circle"), tag: 1)
		
		let settingsView = SettingsViewController(asManager: asManager)
		settingsView.tabBarItem = .init(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
		
		self.setViewControllers([nowView, helpView, settingsView], animated: false)
	}
}
