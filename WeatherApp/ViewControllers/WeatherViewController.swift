//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Sam King on 1/29/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

import UIKit
import SVProgressHUD

class WeatherViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate{
    
    var darkWeatherData: DarkSkyWeather?
    let currWeather: CurrentWeather = .fromNib()
    var foreWeather: ForecastWeather = .fromNib()
    
    @IBOutlet weak var textField: UITextField!{
        didSet{
            textField.delegate = self
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
    
    func load(completion: @escaping () -> ()) {
        if let location = Locator.main.location
        {
            WeatherApiClient(baseUrl: DarkSkyAPI.baseURL).retrieveCurrentWeather(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude)) { (result) in
                switch result {
                case .success(let darkWeatherData):
                    self.darkWeatherData = darkWeatherData
                    self.reloadUI()
                case .failure(let error):
                    Alert.error(error.localizedDescription)
                }
                completion()
            }
        } else {
            Alert.error("Please Enable Location Services in Settings For Weather Data")
        }
        
    }
    
    func reloadUI() {
        if let temp = self.darkWeatherData?.currentTemp {
            self.currWeather.temp.text = String(temp)
        }
        if let icon = self.darkWeatherData?.currentTempIcon {
            self.currWeather.icon.text = String(icon)
        }
    }
    
    //MARK: - Scrollview Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    //MARK: - Textfield Methods

}

