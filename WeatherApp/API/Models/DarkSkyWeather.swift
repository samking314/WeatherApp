//
//  DarkSkyWeather.swift
//  WeatherApp
//
//  Created by Sam King on 1/30/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

import Foundation
import ObjectMapper

class DarkSkyWeather: Mappable {
    var currentTemp:      Int?
    var currentTempIcon:  String?
    var forecastTempIcon: String?
    var forecastSum:      String?

    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        currentTemp      <- map["currently.temperature"]
        currentTempIcon  <- map["currently.icon"]
        forecastSum      <- map["daily.summary"]
        forecastTempIcon <- map["daily.icon"]
    }
}

