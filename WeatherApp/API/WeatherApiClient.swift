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
    
    fileprivate var __authorizedSessionManager: SessionManager?
    var authorizedSessionManager: SessionManager? {
        if let existing = __authorizedSessionManager {
            return existing
        }
        
        let headers = SessionManager.defaultHTTPHeaders
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        
        let sm = SessionManager(configuration: configuration)
        __authorizedSessionManager = sm
        
        return __authorizedSessionManager
    }
    
    var unauthorizedSessionManager: SessionManager = {
        return Alamofire.SessionManager.default
    }()
    
    var sessionManager: SessionManager {
        if let sm = authorizedSessionManager {
            return sm
        } else {
            return unauthorizedSessionManager
        }
    }
    
    //MARK: - Dark Sky API calls
    func makeDarkSkyAPIUrl(path: String) -> URL {
        return DarkSkyAPI.authenticatedBaseURL.appendingPathComponent(path)
    }
    
    func retrieveCurrentWeather(latitude: String,
                                longitude: String,
                                completion: @escaping (Result<DarkSkyWeather>) -> Void) {
        let location = latitude + "," + longitude
        let url = makeDarkSkyAPIUrl(path: location)
        let params: [String: Any] = [:]
        sessionManager.request(url,
                               method: .get,
                               parameters: params)
            .validate().responseObject { (response: DataResponse<DarkSkyGenResp>) in
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
