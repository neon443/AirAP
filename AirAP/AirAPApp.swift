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
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
//		if #unavailable(iOS 14) {
		if #available(iOS 14, *) {
			window = UIWindow(frame: UIScreen.main.bounds)
			let view = ContentView()
			let hostingController = UIHostingController(rootView: view)
			window?.rootViewController = hostingController
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
