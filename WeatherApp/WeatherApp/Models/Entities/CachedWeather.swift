//
//  CachedWeather.swift
//  WeatherApp
//
//  Created by Mazen Amr on 24/06/2026.
//

import SwiftData
import Foundation

@Model
class CachedWeather {
    @Attribute(.unique) var id: String
    var weatherData: Data
    
    init(id: String, weatherData: Data) {
        self.id = id
        self.weatherData = weatherData
    }
}
