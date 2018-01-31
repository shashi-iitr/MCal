//
//  WeatherManager.swift
//  MCalApp
//
//  Created by shashi kumar on 31/01/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import CoreLocation

class Daily: NSObject {
    var summary: String!
    var dailyTemps: [DailyTemp]!
    
    init(summary: String, dailyTemps: [DailyTemp]) {
        self.summary = summary
        self.dailyTemps = dailyTemps
    }
}

class DailyTemp: NSObject {
    var time: Double!
    var summary: String!
    var temperatureMin: NSNumber!
    var temperatureMax: NSNumber!

    init(tempMin: NSNumber, tempMax: NSNumber, time: Double, summary: String) {
        self.time = time
        self.summary = summary
        self.temperatureMin = tempMin
        self.temperatureMax = tempMax
    }
}

class Current: NSObject {
    var time: Double!
    var summary: String!
    var temperature: NSNumber!
    
    init(temp: NSNumber, time: Double, summary: String) {
        self.time = time
        self.summary = summary
        self.temperature = temp
    }
}

class Weather: NSObject {
    
    var currenlty: Current!
    var daily: Daily!
    
    init(dTemp: Daily, cTemp: Current) {
        self.daily = dTemp
        self.currenlty = cTemp
    }
}

class WeatherManager: NSObject {
    
    //https://api.darksky.net/forecast/fab8312c1a233e2713f005f4119bc66c/28.557674,77.2437853
    func fetchWeatherDataForLocation(_ location: CLLocation, success:@escaping (_ weather: Weather) -> Void, failure:@escaping (NSError?) -> Void) -> Void {
        let path = "https://api.darksky.net/forecast/fab8312c1a233e2713f005f4119bc66c/\(location.coordinate.latitude),\(location.coordinate.longitude)"
        
        let url = URL(string: path)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, res, err) in
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    var curr: Current!
                    if let currently = json["currently"] as? NSDictionary {
                        curr = Current.init(temp: currently["temperature"] as! NSNumber, time: currently["time"] as! Double, summary: currently["summary"] as! String)
                    }
                    
                    var daily: Daily!
                    if let dailyData = json["daily"] as? NSDictionary {
                        let summary = dailyData["summary"] as! String
                        var dailyTemps = [DailyTemp]()
                        if let data = dailyData["data"] as? NSArray {
                            for i in 0..<data.count {
                                let dataItem = data[i] as! NSDictionary
                                let dailyTemp = DailyTemp.init(tempMin: dataItem["temperatureMin"] as! NSNumber, tempMax: dataItem["temperatureMax"] as! NSNumber, time: dataItem["time"] as! Double, summary: dataItem["summary"] as! String)
                                dailyTemps.append(dailyTemp)
                            }
                        }
                        
                        daily = Daily.init(summary: summary, dailyTemps: dailyTemps)
                    }
                    
                    let weather = Weather.init(dTemp: daily, cTemp: curr)
                    print("weather \(weather)")
                    print("weather.currenlty \(weather.currenlty)")
                    print("weather.daily \(weather.daily)")
                    print("weather.daily[0] \(weather.daily.dailyTemps[0])")
                    success(weather)
                } else {
                    failure(err! as NSError)
                }
            } catch {
                print("Error deserializing JSON: \(error)")
                failure(error as NSError)
            }
        }
        
        task.resume()
    }
}

protocol LocationManagerDelegate: class {
    func userLocationUpdated(_ location: CLLocation?, isLocated: Bool)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var locManager: CLLocationManager?
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
    }
    
    func fetchCurrentLocation() -> Void {
        if CLLocationManager.locationServicesEnabled() {
            locManager = CLLocationManager()
            locManager?.delegate = self
            locManager?.distanceFilter = kCLDistanceFilterNone
            locManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locManager?.requestWhenInUseAuthorization()
            locManager?.startUpdatingLocation()
        } else {
            if let delegate = delegate {
                delegate.userLocationUpdated(nil, isLocated: false)
            }
        }
    }
    
    //MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations...")
        locManager?.stopUpdatingLocation()
        if let delegate = delegate {
            delegate.userLocationUpdated(locations.last, isLocated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch (status) {
        case .notDetermined:
            print("user still thinking...")
        case .denied:
            print("user still denied...")
        case .authorizedWhenInUse:
            print("user authorizedWhenInUse...")
        case .authorizedAlways:
            print("user authorizedAlways...")
        case .restricted:
            print("user restricted...")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError...")
        if let delegate = delegate {
            delegate.userLocationUpdated(nil, isLocated: false)
        }
    }
}
