//
//  AirAPApp.swift
//  AirAP
//
//  Created by neon443 on 16/05/2025.
//

import SwiftUI

@main
class AirAPApp: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	
	@available(iOS 13, *)
	func application(
		_ application: UIApplication,
		configurationForConnecting connectingSceneSession: UISceneSession,
		options: UIScene.ConnectionOptions
	) -> UISceneConfiguration {
		if #available(iOS 14, *) {
			let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
			config.delegateClass = SceneDelegate.self
			return config
		} else {
			fatalError()
		}
	}
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
		if #available(iOS 14, *) {
		} else {
			window = UIWindow(frame: UIScreen.main.bounds)
			window?.rootViewController = UIViewController()
			
			let label = UILabel()
			label.text = "hello uikit"
			label.frame = window!.frame
			label.translatesAutoresizingMaskIntoConstraints = false
			
			window?.rootViewController?.view.addSubview(label)
			window?.rootViewController?.view.bringSubviewToFront(label)
		}
		window?.makeKeyAndVisible()
		return true
	}
}
