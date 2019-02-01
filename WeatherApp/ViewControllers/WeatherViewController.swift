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
        
        let currWeather:CurrentWeather = Bundle.main.loadNibNamed("CurrentWeather", owner: self, options: nil)?.first as! CurrentWeather
        
        let foreWeather:ForecastWeather = Bundle.main.loadNibNamed("ForecastWeather", owner: self, options: nil)?.first as! ForecastWeather
        
        currWeather.frame = CGRect(x: scrollView.frame.width * 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        foreWeather.frame = CGRect(x: scrollView.frame.width * 1, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width * 2, height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        scrollView.addSubview(currWeather)
        scrollView.addSubview(foreWeather)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }

}

