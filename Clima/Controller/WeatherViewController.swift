//
//  WeatherViewController.swift
//  Clima
//
//  Created by Andrey Alymov on 24.08.2021.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var conditionView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManeger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManeger.delegate = self
        locationManeger.requestWhenInUseAuthorization()
        locationManeger.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self

    }

    @IBAction func CurrentLocation(_ sender: UIButton) {
        locationManeger.requestLocation()
    }
    
}

//MARK: - UITextField Delegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            searchTextField.placeholder = "Type something to search"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManegerDelegate {
    
    func updateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.tempLabel.text = weather.temperatureString
            self.conditionView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func errorWeather(error: Error) {
        print(error)
    }
}

//MARK: - LocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManeger.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
    
    

