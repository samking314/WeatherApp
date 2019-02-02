//
//  DarkSkyWeather.swift
//  WeatherApp
//
//  Created by Sam King on 1/30/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

/**************
 
 TO DO:
 1. Format Model to correctly serve ApiClient
 
 **************/

import Foundation
import ObjectMapper

class DarkSkyWeather: Mappable {
    var currentTemp:     Int?
    var currentTempIcon: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        currentTemp     <- map["temperature"]
        currentTempIcon <- map["icon"]
    }
}

