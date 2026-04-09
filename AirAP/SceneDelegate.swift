//
//  SceneDelegate.swift
//  AirAP
//
//  Created by neon443 on 09/04/2026.
//

import Foundation
import SwiftUI

@available(iOS 13, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?
	
	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let windowScene = scene as? UIWindowScene else { return }
		let window = UIWindow(windowScene: windowScene)
		let contentView = ContentView()
		let hostingController = UIHostingController(rootView: contentView)
		
		window.rootViewController = hostingController
		self.window = window
		window.makeKeyAndVisible()
	}
}
