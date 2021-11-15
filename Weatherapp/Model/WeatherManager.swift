//
//  WeatherManager.swift
//  Weatherapp
//
//  Created by Mai Uchida on 2021/11/14.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    private var apikey: String
    private var apiUri: String
    
    private var apiKey: String {
      get {
        // 1
        guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
          fatalError("Couldn't find file 'Secrets.plist'.")
        }
        // 2
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
          fatalError("Couldn't find key 'API_KEY' in 'Secrets.plist'.")
        }
        return value
      }
        set{
            apikey = "\(newValue)"
            apiUri = "https://api.openweathermap.org/data/2.5/weather?appid=\(apikey)&units=metric"
        }
    }
    
     func fetchWeather(cityName: String){
         let urlString = "\(apiUri)&q=\(cityName)"
         performRequest(with: urlString)
     }
     func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
         let urlString = "\(apiUri)&lat=\(latitude)&lon=\(longitude)"
         performRequest(with: urlString)
     }
    
    var delegate: WeatherManagerDelegate?
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, request, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do{
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let feels = decodeData.main.feelsLike
            let name = decodeData.name
            
            let weather = WeatherModel(conditionalId: id, cityName: name, temperature: temp, feels: feels)
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
