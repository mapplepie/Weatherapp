//
//  WeatherData.swift
//  Weatherapp
//
//  Created by Mai Uchida on 2021/11/14.
//

import Foundation

struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
    
}
struct Main: Codable{
    let temp: Double
    let feelsLike: Double
}

struct Weather: Codable{
    let id: Int
}
