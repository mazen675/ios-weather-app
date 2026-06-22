//
//  FavoriteCity.swift
//  WeatherApp
//
//  Created by Mazen Amr on 22/06/2026.
//

import Foundation
import SwiftData

@Model
class FavoriteCity {
    @Attribute(.unique) var id: String
    var name: String
    var lat: Double
    var lon: Double
    var weatherData: Data?
    
    init(name: String, lat: Double, lon: Double, weatherData: Data? = nil) {
        self.id = "\(lat),\(lon)"
        self.name = name
        self.lat = lat
        self.lon = lon
        self.weatherData = weatherData
    }
}
