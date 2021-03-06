//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Sam King on 1/29/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

/***************
 
 TODO:
 1. Indicate the location of the weather(uilabel maybe below 'Current Weather' in main.storyboard)
 
 ***************/

import UIKit
import SVProgressHUD
import CoreLocation
import UserNotifications

class WeatherViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate{
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let currWeather: CurrentWeather = .fromNib()
    var foreWeather: ForecastWeather = .fromNib()
    
    let geoCoder = CLGeocoder()
    
    @IBOutlet weak var locationTextField: UITextField!{
        didSet{
            locationTextField.delegate = self
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWeatherScrollView()
        
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        
        loadWithHud()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reloadUI()
    }

    func setupWeatherScrollView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scrollView.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * 2, height: scrollView.frame.size.height)
        scrollView.isPagingEnabled = true
        
        setupCustomViews()
        
        scrollView.addSubview(currWeather)
        scrollView.addSubview(foreWeather)
    }
    
    func setupCustomViews() {
        currWeather.frame = CGRect(x: scrollView.frame.size.width * 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        foreWeather.frame = CGRect(x: scrollView.frame.size.width * 1, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
    }
    
    func loadWithHud() {
        SVProgressHUD.show()
        load {
            SVProgressHUD.popActivity()
        }
    }
    
    func newLocationLoadWithHud(location: CLLocation) {
        SVProgressHUD.show()
        newLocationWeather(location: location) {
            SVProgressHUD.popActivity()
        }
    }
    
    func load(completion: @escaping () -> ()) {
        if let location = Locator.main.location
        {
            let queue = DispatchQueue(label: "com.WeatherApp.Utility", qos: .utility)
            queue.async {
                WeatherApiClient.sharedDSWApi.retrieveDarkSkyWeather(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude)) { result in
                    if result {
                        self.reloadUI()
                    } else {
                        Alert.error(vc: self, message: "Error retrieving updated Weather Info")
                    }
                }
            }
        }
        completion()
    }
    
    func reloadUI() {
        if let currtemp = WeatherStore.shared.currentTemperature {
            self.currWeather.temp.text = String(currtemp) + "°F"
        }
        if let curricon = WeatherStore.shared.currentWeatherIcon {
            self.currWeather.icon.text = String(curricon)
        }
        if let foresum = WeatherStore.shared.forecastSummary {
            self.foreWeather.forecast.text = String(foresum)
        }
        if let foreicon = WeatherStore.shared.forecastWeatherIcon {
            self.foreWeather.icon.text = String(foreicon)
        }
    }
    
    func checkReloadUI() {
        let same = checkWeatherChanged()
        if !same {
            reloadUI()
        }
    }
    
    func newLocationWeather(location: CLLocation, completion: @escaping () -> ()) {
        let queue = DispatchQueue(label: "com.WeatherApp.Utility", qos: .utility)
        queue.async {
            WeatherApiClient.sharedDSWApi.retrieveDarkSkyWeather(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude)) { result in
                if result {
                    self.reloadUI()
                }
                completion()
            }
        }
    }
    
    //MARK: - Scrollview Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    //MARK: - Textfield Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        geoCoder.geocodeAddressString(locationTextField.text ?? "") { (placemark, error) in
            guard
                let placemark = placemark,
                let location = placemark.first?.location
                else {
                    Alert.error(vc: self, message: "Unable to find this location. Please enter a different location.")
                    return
                }
            self.newLocationLoadWithHud(location: location)
        }
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Helper Methods
    func checkWeatherChanged() -> Bool {
        if let currtemp = WeatherStore.shared.currentTemperature,
            let curricon = WeatherStore.shared.currentWeatherIcon,
            let foresum = WeatherStore.shared.forecastSummary,
            let foreicon = WeatherStore.shared.forecastWeatherIcon{
            if String(currtemp) + "°F" == self.currWeather.temp.text,
                String(curricon) == self.currWeather.icon.text,
                String(foresum) == self.foreWeather.forecast.text,
                String(foreicon) == self.foreWeather.icon.text {
                return true
            }
        }
        return false
    }
   
}

