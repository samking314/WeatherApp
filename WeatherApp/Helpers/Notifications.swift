//
//  Notifications.swift
//  WeatherApp
//
//  Created by Sam King on 2/3/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

import Foundation

import UserNotifications

class Notifications: NSObject {
    
    class func displayWeatherChangeNotif() {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "The weather has changed!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: WeatherStore.shared.currentWeatherIcon ?? "open the app to find out...", arguments: nil)
        content.sound = UNNotificationSound.default
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "UpdatedWeather", content: content, trigger: trigger) // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print("OUR ERROR :: \(theError)")
            }
        }
    }
    
}
