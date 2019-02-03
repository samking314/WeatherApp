//
//  Alert.swift
//  WeatherApp
//
//  Created by Sam King on 2/1/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

import Foundation
import UIKit

class Alert: NSObject {
    
    class func error(vc: UIViewController, message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            print("You've pressed OK");
        }
        
        alertController.addAction(action)
        vc.present(alertController, animated: true, completion: nil)
    }
}
