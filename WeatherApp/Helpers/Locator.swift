//
//  Locator.swift
//  WeatherApp
//
//  Created by Sam King on 2/2/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

/**************
 
 TO DO:
 1. use updated location to serve new weather
 
 **************/

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
        if CLLocationManager.locationServicesEnabled(), let location = Locator.main.location
        {
            WeatherApiClient.sharedDSWApi.retrieveDarkSkyWeather(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude)) { result in
                if result {
                    NotificationCenter.default.post(name: Notification.Name("didReceiveWeatherData"), object: self, userInfo: ["background":false])
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
