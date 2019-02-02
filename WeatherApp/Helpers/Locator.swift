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
    
    static let DidUpdateLocation: NSNotification.Name = NSNotification.Name(rawValue: "LocatorDidUpdateLocation")
    static let DidUpdateCurrentCity: NSNotification.Name = NSNotification.Name(rawValue: "DidUpdateCurrentCity")
    
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
    
    fileprivate var cityUpdateDate: Date?
    var city: String? {
        didSet {
            cityUpdateDate = Date()
            NotificationCenter.default.post(name: Locator.DidUpdateCurrentCity, object: self)
        }
    }
    var state: String? {
        didSet {
            cityUpdateDate = Date()
            NotificationCenter.default.post(name: Locator.DidUpdateCurrentCity, object: self)
        }
    }
    var country: String? {
        didSet {
            cityUpdateDate = Date()
            NotificationCenter.default.post(name: Locator.DidUpdateCurrentCity, object: self)
        }
    }
    var address: String? {
        didSet {
            cityUpdateDate = Date()
            NotificationCenter.default.post(name: Locator.DidUpdateCurrentCity, object: self)
        }
    }
    
    func updateCurrentCityIfNeeded() {
        if let date = cityUpdateDate,
            let diff = Calendar.current.dateComponents([.minute], from: date, to: Date()).minute, diff > 10 {
            updateCurrentCity()
        } else if cityUpdateDate == nil {
            updateCurrentCity()
        }
    }
    
    func updateCurrentCity() {
        guard let l = location else { return }
        CLGeocoder().reverseGeocodeLocation(l) { [weak self] (placemarks, error) in
            guard let placemark = placemarks?.first else {
                let errorString = error?.localizedDescription ?? "Unexpected Error"
                print("Unable to reverse geocode the given location. Error: \(errorString)")
                return
            }
            print(placemark)
            self?.city = placemark.locality
            self?.state = placemark.administrativeArea
            self?.country = placemark.country
            self?.address = "\(placemark.subLocality ?? ""), \(placemark.thoroughfare ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.postalCode ?? ""), \(placemark.country ?? "")"
        }
    }
}

extension Locator: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        NotificationCenter.default.post(name: Locator.DidUpdateLocation, object: self)
        updateCurrentCityIfNeeded()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
