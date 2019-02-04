//
//  Locator.swift
//  WeatherApp
//
//  Created by Sam King on 2/2/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

import Foundation
import CoreLocation

class Locator: NSObject {
    
    static let main = Locator()
    
    var location: CLLocation? {
        return locationManager.location
    }
    
    let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager(locationManager, didChangeAuthorization: CLLocationManager.authorizationStatus())
    }
}

extension Locator: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        NotificationCenter.default.post(name: .didUpdateLocation, object: self)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension Notification.Name {
    static let didUpdateLocation = NSNotification.Name(rawValue: "LocatorDidUpdateLocation")
}
