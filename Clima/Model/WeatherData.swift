//
//  WeatherData.swift
//  Clima
//
//  Created by Andrey Alymov on 25.08.2021.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

struct Main: Codable {
    let temp: Double
    let pressure: Int
}

struct Weather: Codable {
    let description: String
    let id: Int
    let icon: String
}

struct Wind: Codable {
    let speed: Double
}
