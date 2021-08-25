//
//  WeatherManager.swift
//  Clima
//
//  Created by Andrey Alymov on 25.08.2021.
//

import Foundation
import CoreLocation

protocol WeatherManegerDelegate {
    func updateWeather (_ weatherManager: WeatherManager, weather: WeatherModel)
    func errorWeather (error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=\(wheaterApiKey)"
    
    var delegate: WeatherManegerDelegate?
    
    func fetchWeather (cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather (latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest (with urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.errorWeather(error: error!)
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        delegate?.updateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func parseJSON (_ weatherData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let description = decodedData.weather[0].description
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, description: description)
            return weather
        } catch {
            print(error)
            return nil
        }
    }
}
