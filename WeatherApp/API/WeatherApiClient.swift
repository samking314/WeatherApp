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

struct WeatherApiConfig {
    
    //MARK: - Our Company Weather Server URL for internal API Requests later on
    static let baseURL = URL(string: "weatherserverURL")!
    
}

final class WeatherApiClient {
    
    let baseUrl: URL
    
    init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    //MARK: - Dark Sky API
    func makeDarkSkyAPIUrl(path: String) -> URL {
        return DarkSkyAPI.authenticatedBaseURL.appendingPathComponent(path)
    }
    
    func retrieveCurrentWeather(latitude: String,
                                longitude: String,
                                completion: @escaping (Result<DarkSkyWeather>) -> Void) {
            let url = "https://api.darksky.net/forecast/2b224e64b6ec762d7d4d1443388f7f55/33.748997,-84.387985"
            let params: [String: Any] = [:]
            Alamofire.request(url, method: .get, parameters: params)
                .validate().responseObject {
                    (response: DataResponse<DarkSkyGenResp>) in
                    print("HERE")
                    print(response)
                    switch response.result {
                    case .success(let object):
                        completion(object.result())
                    case .failure(let error):
                        completion(.failure(error))
                    }
            }
        
    }
    
}
