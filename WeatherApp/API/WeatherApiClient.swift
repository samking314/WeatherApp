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

struct WeatherApiConfig {
    
    //MARK: - Weather Server URL for API Requests later on
    static let baseURL = URL(string: "weatherserverURL")!
    
}

final class WeatherApiClient {
    
    let baseUrl: URL
    
    init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    func makeUrl(path: String) -> URL {
        return baseUrl.appendingPathComponent(path)
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
    
    func retrieveCurrentWeather(completion: @escaping (Result<DarkSkyWeather>) -> Void) {
        let url = makeUrl(path: "retrievehomepagecontent")
        let params: [String: Any] = []
        sessionManager.request(url,
                               method: .post,
                               parameters: params)
            .validate().responseObject { (response: DataResponse<GenericResponse>) in
                switch response.result {
                case .success(let object):
                    let r: Result<PaginatedArticles> = object.result()
                    completion(r)
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
}
