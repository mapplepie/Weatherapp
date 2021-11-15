//
//  File.swift
//  Weatherapp
//
//  Created by Mai Uchida on 2021/11/14.
//

import Foundation

struct WeatherModel{
    let conditionalId: Int
    let cityName: String
    let temperature: Double
    let feels: Double
    
    
    var temperatureString: String{
        return String(format: "%.1f", temperature)
    }
    var feelsString: String{
        return String(format: "%.1f", feels)
    }
    
    var conditionName: String{
        switch conditionalId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    
}
