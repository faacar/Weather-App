//
//  WeatherData.swift
//  Weather App
//
//  Created by Ahmet Acar on 12.12.2020.
//  Copyright © 2020 Ahmet Acar. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Weather: Decodable {
    let id: Int
    let description: String
}

struct Main: Decodable {
    let temp: Float
}
