//
//  UserStore.swift
//  WeatherApp
//
//  Created by Sam King on 2/2/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

import Foundation

class UserStore {
    
    static let shared: UserStore = UserStore()
    
    var currentTemperature: String? {
        let prefs = UserDefaults.standard
        if let currTemp = prefs.object(forKey: "currentTemperature") as? String{
            return currTemp
        }
        return nil
    }
    
    var currentWeatherIcon: String? {
        let prefs = UserDefaults.standard
        if let currIcon = prefs.object(forKey: "currentWeatherIcon") as? String{
            return currIcon
        }
        return nil
    }
    
    var forecastSummary: String? {
        let prefs = UserDefaults.standard
        if let foreSum = prefs.object(forKey: "forecastSummary") as? String{
            return foreSum
        }
        return nil
    }
    
    var forecastWeatherIcon: String? {
        let prefs = UserDefaults.standard
        if let foreIcon = prefs.object(forKey: "forecastWeatherIcon") as? String{
            return foreIcon
        }
        return nil
    }
}
