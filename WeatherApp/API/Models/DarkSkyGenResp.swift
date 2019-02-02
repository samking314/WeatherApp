//
//  DarkSkyGenResp.swift
//  WeatherApp
//
//  Created by Sam King on 1/31/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class DarkSkyGenResp: Mappable {
    var statusCode: Int?
    var message:    String?
    var data:       [String : Any]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        statusCode <- map["Status Code"]
        data       <- map["currently"]
        message    <- map["message"]
    }
    
    fileprivate func dataDictionary(key: String? = nil) -> [String: Any]? {
        if let k = key, let d = data?[k] as? [String : Any] {
            return d
        } else if let d = data {
            return d
        }
        return nil
    }
    
    func decodeData<T: BaseMappable>(key: String? = nil) -> T? {
        if let d = dataDictionary(key: key) {
            let object = Mapper<T>().map(JSON: d)
            return object
        }
        return nil
    }
}

extension DarkSkyGenResp {
    func result<T: BaseMappable>(key: String? = nil) -> Result<T> {
        var r: Result<T>?
        if let value: T = decodeData(key: key) {
            r = .success(value)
        } else if statusCode != 200  {
            r = .failure(WeatherApiError.apiError(message: "success"))
        }
        if r == nil {
            r = .failure(WeatherApiError.unknownError)
        }
        return r!
    }
}
