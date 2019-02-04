//
//  WeatherStore.swift
//  WeatherApp
//
//  Created by Sam King on 2/2/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

import Foundation

class WeatherStore {
    
    static let shared: WeatherStore = WeatherStore()
    
    var weatherApiType: String?
    
    static let weatherIcons: [String : String] = ["clear-day":"🌞", "clear-night":"🌚", "rain":"🌧", "snow":"❄️", "sleet":"🌨", "wind":"💨", "fog":"🌁", "cloudy":"🌥", "partly-cloudy-day":"⛅️", "partly-cloudy-night":"☁️", "default":"🌈"] //fun to play around with :)
    
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
            if let apiType = weatherApiType{
                switch apiType{
                case DarkSkyConfig.apiname:
                    if let icon = WeatherStore.weatherIcons[currIcon] {
                        return icon
                    } else {
                        return WeatherStore.weatherIcons["default"]
                    }
                default:
                    return currIcon
                }
            }
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
            if let apiType = weatherApiType{
                switch apiType{
                case DarkSkyConfig.apiname:
                    if let icon = WeatherStore.weatherIcons[foreIcon] {
                        return icon
                    } else {
                        return WeatherStore.weatherIcons["default"]
                    }
                default:
                    return foreIcon
                }
            }
            return foreIcon
        }
        return nil
    }
}
