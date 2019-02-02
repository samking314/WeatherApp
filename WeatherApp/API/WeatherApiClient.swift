//
//  WeatherApiClient.swift
//  WeatherApp
//
//  Created by Sam King on 1/30/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

/**************
 
 TO DO:
 1. Grab first bit of data from Dark Sky API

 **************/

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SVProgressHUD

struct WeatherApiConfig {
    
    //MARK: - Dark Sky API Config
    static let dwBaseURL = URL(string: "https://api.darksky.net/forecast/")!
    static var dwAuthenticatedBaseURL: URL {
        return dwBaseURL.appendingPathComponent(DarkSkyConfig.apikey)
    }
    
    //MARK: - place other API Configs below
    
}

final class WeatherApiClient {
    
    let baseUrl: URL
    
    init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    //MARK: - Dark Sky API
    static let sharedDWApi: WeatherApiClient = {
        return WeatherApiClient(baseUrl: WeatherApiConfig.dwAuthenticatedBaseURL)
    }()
    
    func makeDarkSkyAPIUrl(path: String) -> URL {
        return baseUrl.appendingPathComponent(path)
    }
    
    func retrieveDarkSkyWeather(latitude: String,
                                longitude: String, completion: @escaping (Bool) -> ()) {
            let location = latitude + "," + longitude
            let url = makeDarkSkyAPIUrl(path: location)
            Alamofire.request(url, method: .get).responseObject { (response: DataResponse<DarkSkyWeather>) in
                if let darkSkyWeather = response.result.value {
                    UserDefaults.standard.set(String(darkSkyWeather.currentTemp ?? 0), forKey: "currentTemperature")
                    UserDefaults.standard.set(darkSkyWeather.currentTempIcon ?? "rainy", forKey: "currentWeatherIcon")
                    UserDefaults.standard.set(darkSkyWeather.forecastSum ?? "0", forKey: "forecastSummary")
                    UserDefaults.standard.set(darkSkyWeather.forecastTempIcon ?? "rainy", forKey: "forecastWeatherIcon")
                    completion(true)
                } else {
                    Alert.error("Error retrieving updated Weather Info")
                    completion(false)
                }
            }
    }
}
