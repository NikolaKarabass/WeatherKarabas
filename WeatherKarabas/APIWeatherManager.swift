//
//  APIWeatherManager.swift
//  WeatherKarabas
//
//  Created by Admin on 11/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

enum ForecastType: FinalURLPoint {
    case Current(apiKey: String, coordinates: Coordinates)
    // let urlString = "https://api.openweathermap.org/data/2.5/weather?q=London,uk"
    var baseURL: URL {
        return URL(string: "https://api.apixu.com")!
        //return URL(string: "https://api.forecast.io")!
    }
    
    var path: String {
        switch self {
        case .Current(let apiKey, let coordinates):
            //return "/forecast/\(apiKey)/\(coordinates.latitude),\(coordinates.longitude)"
            return "/v1/current.json?key=77617252a835443c95b93103191105&q=Paris"
            
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        //let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=London,uk")
        
        return URLRequest(url: url!)
    }
}

final class APIWeatherManager: APIManager {
    
    let sessionConfiguration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    }()
    
    let apiKey: String
    // init
    init(sessionConfiguration: URLSessionConfiguration, apiKey: String) {
        self.sessionConfiguration = sessionConfiguration
        self.apiKey = apiKey
    }
    // init for apikey
    convenience init(apiKey: String) {
        self.init(sessionConfiguration: URLSessionConfiguration.default, apiKey: apiKey)
    }
    
    func fetchCurrentWeatherWith(coordinates: Coordinates, completionHandler: @escaping (APIResult<CurrentWeather>) -> Void) {
        let request = ForecastType.Current(apiKey: self.apiKey, coordinates: coordinates).request
        fetch(request: request, parse: { (json) -> CurrentWeather? in
            if let dictionary = json["current"] as? [String: AnyObject] {
                return CurrentWeather(JSON: dictionary)
            } else {
                return nil
            }
        }, completionHandler: completionHandler)
    }
}





