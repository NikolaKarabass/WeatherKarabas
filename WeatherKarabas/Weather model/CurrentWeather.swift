//
//  CurrentWeather.swift
//  WeatherKarabas
//
//  Created by Admin on 09/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//
//JSON Example of API response:
//{"coord":
//    {"lon":145.77,"lat":-16.92},
//    "weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04n"}],
//    "base":"cmc stations",
//    "main":{"temp":293.25,"pressure":1019,"humidity":83,"temp_min":289.82,"temp_max":295.37},
//    "wind":{"speed":5.1,"deg":150},
//    "clouds":{"all":75},
//    "rain":{"3h":3},
//    "dt":1435658272,
//    "sys":{"type":1,"id":8166,"message":0.0166,"country":"AU","sunrise":1435610796,"sunset":1435650870},
//    "id":2172797,
//    "name":"Cairns",
//    "cod":200}

import Foundation
import UIKit

struct CurrentWeather {
    let temperature: Double
    let apparentTemperature: Double
    let humidity: Int64
    let pressure: Double
    //    let icon: UIImage
}

extension CurrentWeather: JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        guard let temperature = JSON["temp_f"] as? Double,   //JSON["temperature"] as
            let apparentTemperature = JSON["feelslike_c"] as? Double,
            let humidity = JSON["humidity"] as? Int64,
            let pressure = JSON["pressure_in"] as? Double else {
                //    let iconString = JSON["icon"] as? String else {
                return nil
        }
        
        //   let icon = WeatherIconManager(rawValue: iconString).image
        
        self.temperature = temperature
        self.apparentTemperature = apparentTemperature
        self.humidity = humidity
        self.pressure = pressure
        //  self.icon = icon
    }
}

extension CurrentWeather {
    var pressureString: String {
        return "\(Int(pressure)) mm"
    }
    
    var humidityString: String {
        return "\(Int(humidity)) %"
    }
    
    var temperatureString: String {
        return "\(Int(temperature))˚C"
    }
    
    var apparentTemperatureString: String {
        return "Feels like: \(Int(apparentTemperature))˚C"
    }
}


