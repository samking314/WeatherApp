//
//  WeatherApiError.swift
//  WeatherApp
//
//  Created by Sam King on 1/31/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

import Foundation

enum WeatherApiError: Error {
    case apiError(message: String)
    case decodeError
    case unknownError
    case darkSkyDataError
}

extension WeatherApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .apiError(let message):
            return message
        case .decodeError:
            return "Decode error"
        case .unknownError:
            return "Unknown error occured"
        case .darkSkyDataError:
            return "Unknown errors. Server side error [corrupted_data]"
        }
    }
}
