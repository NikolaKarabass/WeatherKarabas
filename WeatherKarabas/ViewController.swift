//
//  ViewController.swift
//  WeatherKarabas
//
//  Created by Admin on 09/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var apparentTemperatureLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        temperatureLabel.text = "22˚C"
    }
    
    lazy var weatherManager = APIWeatherManager(apiKey: "77617252a835443c95b93103191105")
    let coordinates = Coordinates(latitude: 47.24, longitude: 38.9)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        weatherManager.fetchCurrentWeatherWith(coordinates: coordinates) { (result) in
            switch result {
            case .Success(let currentWeather):
                self.updateUIWith(currentWeather: currentWeather)
            case .Failure(let error as NSError):
                let alertController = UIAlertController(title: "Unable to get data", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            default: break
            }
        }
        
        //        let icon = WeatherIconManager.ClearDay.image
        // init CurrentWeather with data0
        //       let currentWeather = CurrentWeather(temperature: 16.5, apparentTemperature: 9.5, humidity: 30, pressure: 760, icon: icon)
        
        //updateUIWith(currentWeather: currentWeather)
    }
    
    func updateUIWith(currentWeather: CurrentWeather) {
        
        //   self.imageView.image = currentWeather.icon
        self.pressureLabel.text = currentWeather.pressureString
        self.humidityLabel.text = currentWeather.humidityString
        self.temperatureLabel.text = currentWeather.temperatureString
        self.apparentTemperatureLabel.text = currentWeather.apparentTemperatureString
    }
}


