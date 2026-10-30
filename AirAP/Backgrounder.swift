//
//  Backgrounder.swift
//  AirAP
//
//  Created by neon443 on 29/10/2026.
//

import Foundation
import CoreLocation

class Backgrounder: NSObject, CLLocationManagerDelegate {
	static var shared = Backgrounder()
	
	let locationManager = CLLocationManager()
	var tracking = false
	
	override init() {
		super.init()
		
		locationManager.delegate = self
		if !checkLocPerms() {
		} else {
			locationManager.allowsBackgroundLocationUpdates = true
		}
	}
	
	func start() {
		guard !tracking else { return }
		guard checkLocPerms() else { return }
		locationManager.allowsBackgroundLocationUpdates = true
		locationManager.pausesLocationUpdatesAutomatically = false
		locationManager.startMonitoringSignificantLocationChanges()
		tracking = true
	}
	
	func stop() {
		
		locationManager.stopUpdatingLocation()
		locationManager.allowsBackgroundLocationUpdates = false
		tracking = false
	}
	
	func checkLocPerms() -> Bool {
		if #available(iOS 14, *) {
			let status = locationManager.authorizationStatus
			switch status {
			case .authorizedAlways:
				return true
			case .authorized, .notDetermined, .restricted, .denied, .authorizedWhenInUse:
				return false
			default:
				return false
			}
		} else {
			fatalError("ios 14 needed for checking location perms")
		}
	}
}
