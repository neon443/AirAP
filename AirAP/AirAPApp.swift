//
//  AirAPApp.swift
//  AirAP
//
//  Created by neon443 on 16/05/2025.
//

import UIKit

@main
class AirAPApp: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	var asManager: AirstreamManager = .init()
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		let rootVC = InitialViewController(asManager: asManager)
		window?.rootViewController = rootVC
		window?.makeKeyAndVisible()
		return true
	}
}
