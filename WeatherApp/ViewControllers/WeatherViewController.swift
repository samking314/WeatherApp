//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Sam King on 1/29/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreLocation

class WeatherViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate{
    
    let currWeather: CurrentWeather = .fromNib()
    var foreWeather: ForecastWeather = .fromNib()
    
    var locationSuggestionsControl:  LocationSuggestionsControl?
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
        
        locationSuggestionsControl = LocationSuggestionsControl(textField: locationTextField)
        
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        
        loadWithHud()
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
    
    func newLoadWithHud(location: CLLocation) {
        SVProgressHUD.show()
        self.newWeather(location: location) {
            SVProgressHUD.popActivity()
        }
    }
    
    func load(completion: @escaping () -> ()) {
        if let location = Locator.main.location
        {
            WeatherApiClient.sharedDWApi.retrieveDarkSkyWeather(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude)) { result in
                if (result) {
                    self.reloadUI()
                }
                completion()
            }
        } else {
            Alert.error("Please Enable Location Services in Settings For Weather Data")
        }
    }
    
    func reloadUI() {
        if let currtemp = UserStore.shared.currentTemperature {
            self.currWeather.temp.text = String(currtemp) + "°F"
        }
        if let curricon = UserStore.shared.currentWeatherIcon {
            self.currWeather.icon.text = String(curricon)
        }
        if let foresum = UserStore.shared.forecastSummary {
            self.foreWeather.forecast.text = String(foresum)
        }
        if let foreicon = UserStore.shared.forecastWeatherIcon {
            self.foreWeather.icon.text = String(foreicon)
        }
    }
    
    func newWeather(location: CLLocation, completion: @escaping () -> ()) {
        WeatherApiClient.sharedDWApi.retrieveDarkSkyWeather(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude)) { result in
            if (result) {
                self.reloadUI()
            }
            completion()
        }
    }
    
    //MARK: - Scrollview Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    //MARK: - Textfield Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        geoCoder.geocodeAddressString(locationTextField.text ?? "") { (placemark, error) in
            guard
                let placemark = placemark,
                let location = placemark.first?.location
                else {
                    Alert.error("This location doesn't exist anymore.")
                    return
            }
            self.newLoadWithHud(location: location)
        }
    }
}

