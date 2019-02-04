//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Sam King on 1/29/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

/***************
 
 TODO:
 1. +1 test to ensure sending correct params to WeatherApiClient
 2. +1 test to ensure receiving correct data from WeatherApiClient
 
 ***************/

import XCTest
import ObjectMapper
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    
    var dsWeather: DarkSkyWeather!
    var weatherDictionary: [String: Any] = ["currently":["temperature":60,"icon":"cloudy"],"daily":["icon":"clear-day","summary":"No precipitation throughout the week, with high temperatures peaking at 77°F on Thursday."]]

    override func tearDown() {
        dsWeather = nil
    }

    func testDarkSkyWeather() {
        dsWeather = Mapper<DarkSkyWeather>().map(JSON: weatherDictionary)
        
        XCTAssertEqual(dsWeather?.currentTemp, 60)
        XCTAssertEqual(dsWeather?.currentTempIcon, "cloudy")
        XCTAssertEqual(dsWeather?.forecastTempIcon, "clear-day")
        XCTAssertEqual(dsWeather?.forecastSum, "No precipitation throughout the week, with high temperatures peaking at 77°F on Thursday.")
    }

}
