//
//  DarkSkyConfig.swift
//  WeatherApp
//
//  Created by Sam King on 1/30/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

import Foundation

class DarkSkyAPI {
    
    static let apikey = "2b224e64b6ec762d7d4d1443388f7f55" //this isn't very safe, apikeys should almost always be stored on backend.
    static let baseURL = URL(string: "https://api.darksky.net/forecast/")!
    
    static var authenticatedBaseURL: URL {
        return baseURL.appendingPathComponent(apikey)
    }
    
}
