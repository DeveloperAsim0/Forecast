//
//  ViewController.swift
//  Weather
//
//  Created by Harshil Patel on 8/11/19.
//  Copyright © 2019 Harshil Patel. All rights reserved.
//

import UIKit

import Alamofire

import SwiftyJSON

import NVActivityIndicatorView

import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect (x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)-100, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        
        locationManager.requestWhenInUseAuthorization()
        
        activityIndicator.startAnimating()
        
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var conditionimageView: UIImageView!
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    let apiKey = "5c896e27bbd6e8247fa9ba1ac9d1e24a"
    
    var latitude = 40.7128
    
    var longitude = -74.0060
    
    var activityIndicator: NVActivityIndicatorView!
    
    let locationManager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=imperial").responseJSON {
            response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName  = jsonWeather["icon"].stringValue
                
                self.locationLabel.text = jsonResponse["name"].stringValue
                self.conditionimageView.image = UIImage(named: iconName)
                self.conditionLabel.text = jsonWeather["main"].stringValue
                self.tempLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                self.dayLabel.text = dateFormatter.string(from: date)
                
            }
                self.locationManager.stopUpdatingLocation()
        }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
}
