//
//  SceneDelegate.swift
//  AirAP
//
//  Created by neon443 on 15/10/2026.
//

import Foundation
import UIKit

@available(iOS 13, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = scene as? UIWindowScene else { return }
		window = UIWindow(windowScene: windowScene)
		
		window?.rootViewController = InitialViewController(asManager: AirAPApp.asManager)
		window?.makeKeyAndVisible()
	}
	
	func sceneDidDisconnect(_ scene: UIScene) {
	}
	
	func sceneDidBecomeActive(_ scene: UIScene) {
	}
	
	func sceneWillResignActive(_ scene: UIScene) {
	}
	
	func sceneWillEnterForeground(_ scene: UIScene) {
	}
	
	func sceneDidEnterBackground(_ scene: UIScene) {
	}
}
