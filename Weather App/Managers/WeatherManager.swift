//
//  WeatherManager.swift
//  Weather App
//
//  Created by Ahmet Acar on 12.12.2020.
//  Copyright © 2020 Ahmet Acar. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManger: WeatherManager, weatherModel: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    private let apiKey = {YOUR_KEY}
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let path = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)&units=metric"
        performRequest(with: path)
    }
    
    func fetchWeather(latitute: CLLocationDegrees, longitute: CLLocationDegrees) {
        let path = "https://api.openweathermap.org/data/2.5/weather?&lat=\(latitute)&lon=\(longitute)&appid=\(apiKey)&units=metric"
        performRequest(with: path)
    }
    
    
    
    func performRequest(with urlString: String) {
        //1. Create URL
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weatherModel: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
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
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
