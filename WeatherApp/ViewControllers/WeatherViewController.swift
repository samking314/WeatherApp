//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Sam King on 1/29/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate{
    
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
    }

    func setupWeatherScrollView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scrollView.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * 2, height: scrollView.frame.size.height)
        scrollView.isPagingEnabled = true
        
        let currWeather:CurrentWeather = Bundle.main.loadNibNamed("CurrentWeather", owner: self, options: nil)?.first as! CurrentWeather
        let foreWeather:ForecastWeather = Bundle.main.loadNibNamed("ForecastWeather", owner: self, options: nil)?.first as! ForecastWeather
        
        currWeather.frame = CGRect(x: scrollView.frame.size.width * 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        foreWeather.frame = CGRect(x: scrollView.frame.size.width * 1, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        
        scrollView.addSubview(currWeather)
        scrollView.addSubview(foreWeather)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }

}

