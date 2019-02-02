//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Sam King on 2/1/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

import Foundation
import UIKit

class CurrentWeather: UIView {
    
    @IBOutlet weak var icon: UILabel!
    @IBOutlet weak var temp: UILabel!
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
}
