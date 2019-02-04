//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Sam King on 1/29/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

/***************
 
 TODO:
 1. Improve error handling
 2. Validate local notifications processed correctly
 
 ***************/

import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager!
    
    let center = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Setup Notifications
        center.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound];
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("User won't authorize notifs")
            }
        }
        
        // Setup Location Manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // Fetch data
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        
        return true
    }
    
    //MARK: - Handle Location Services
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            updateWeather() { result in
                if result {
                    self.reloadUI()
                }
            }
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            updateWeather() { result in
                if result {
                    self.reloadUI()
                }
            }
            break
        default:
            break
        }
    }
    
    //MARK: - Handle Background
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler:
        @escaping (UIBackgroundFetchResult) -> Void) {
        updateWeather() { result in
            if result {
                self.reloadUI()
                completionHandler(.newData)
            } else {
                completionHandler(.failed)
            }
        }
    }
    
    func updateWeather(completion: @escaping (Bool) -> ()) {
        var updated = false
        if let location = Locator.main.location
        {
            WeatherApiClient.sharedDSWApi.retrieveDarkSkyWeather(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude)) { result in
                if result {
                    Notifications.displayWeatherChangeNotif(center: self.center)
                    updated = true
                }
            }
        }
        completion(updated)
    }
    
    func reloadUI() {
        if self.window?.rootViewController is WeatherViewController {
            let vc = self.window?.rootViewController as! WeatherViewController
            vc.checkReloadUI()
        }
    }
    
    //MARK: - Handle Notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Play sound and show alert to the user
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // Determine the user action
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            reloadUI()
            print("Default")
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")
        default:
            print("Unknown action")
        }
        completionHandler()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

