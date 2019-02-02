//
//  Alert.swift
//  WeatherApp
//
//  Created by Sam King on 2/1/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

import Foundation
import SCLAlertView

class Alert: NSObject {
    
    class func error(title: String, _ message: String, onDissmis: (() -> ())? = nil) {
        SCLAlertView().showError(title, subTitle: message, closeButtonTitle: "OK").setDismissBlock {
            onDissmis?()
        }
    }
    
    class func error(_ message: String) {
        error(title: "Error", message)
    }
    
    class func success(title: String, _ message: String, onDissmis: (() -> ())? = nil) {
        SCLAlertView().showSuccess(title, subTitle: message, closeButtonTitle: "OK").setDismissBlock {
            onDissmis?()
        }
    }
    
    class func success(_ message: String, onDissmis: (() -> ())? = nil) {
        success(title: "Success", message, onDissmis: onDissmis)
    }
}
