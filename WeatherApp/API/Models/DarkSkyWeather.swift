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
    var messageKey: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        messageKey <- map["message_key"]
    }
}
