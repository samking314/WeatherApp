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
            let location = latitude + "," + longitude
            let url = makeDarkSkyAPIUrl(path: location)
            Alamofire.request(url, method: .get)
                .validate().responseObject { (response: DataResponse<DarkSkyGenResp>) in
                    switch response.result {
                    case .success(let object):
                        completion(object.result())
                    case .failure(let error):
                        completion(.failure(error))
                    }
            }
        
    }
    
}
