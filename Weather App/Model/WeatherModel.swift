//
//  WeatherModel.swift
//  Weather App
//
//  Created by Ahmet Acar on 12.12.2020.
//  Copyright © 2020 Ahmet Acar. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Float
    let description: String
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionImage: String {
        switch conditionId {
        case 200...299:
            return imageName.thunderstorm
        case 300...399:
            return imageName.drizzle
        case 500...599:
            return imageName.rain
        case 600...699:
            return imageName.snow
        case 700...799:
            return imageName.atmosphere
        case 800:
            return imageName.clear
        default:
            return imageName.clouds
        }
    }
}
