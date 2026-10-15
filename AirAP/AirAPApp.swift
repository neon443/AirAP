//
//  AirAPApp.swift
//  AirAP
//
//  Created by neon443 on 16/05/2025.
//

import Foundation
import UIKit

@UIApplicationMain
class AirAPApp: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	static var asManager: AirstreamManager = .init()
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?
	) -> Bool {
		if #unavailable(iOS 13) {
			window = UIWindow(frame: UIScreen.main.bounds)
			let rootVC = InitialViewController(asManager: AirAPApp.asManager)
			window?.rootViewController = rootVC
			window?.makeKeyAndVisible()
		}
		return true
	}
	
	@available(iOS 13, *)
	func application(
		_ application: UIApplication,
		configurationForConnecting connectingSceneSession: UISceneSession,
		options: UIScene.ConnectionOptions
	) -> UISceneConfiguration {
		let config = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
		config.delegateClass = SceneDelegate.self
		return config
	}
}
