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
		let now = NowPlayingViewController(asManager: asManager)
		now.tabBarItem = .init(title: "Now Playing", image: UIImage(systemName: "play.fill"), tag: 0)
		
//		let helpView = HelpView()
//		let helpVC = UINavigationController(rootViewController: UIHostingController(rootView: helpView))
//		npVC.tabBarItem = .init(title: "Help", image: UIImage(systemName: "questionmark.app.fill"), tag: 1)
//		
//		let settingsView = SettingsView(ASmanager: asManager)
//		let settingsVC = UINavigationController(rootViewController: UIHostingController(rootView: settingsView))
//		npVC.tabBarItem = .init(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
		
		self.setViewControllers([now/*, helpVC, settingsVC*/], animated: false)
	}
}
