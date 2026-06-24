//
//  ApiModels.swift
//  WeatherApp
//
//  Created by Mazen Amr on 15/06/2026.
//

import Foundation
import Foundation

struct WeatherResponse: Codable {
    let location: Location
    let current: Current
    let forecast : Forecast
}

struct Location: Codable {
    let name: String
    let region : String
    let country : String
}

struct Current: Codable {
    let tempC: Double
    let isDay: Int
    let condition: Condition
    let windKph: Double
    let humidity: Int
    let feelslikeC: Double?
    let pressureMb: Double?
}

struct Condition: Codable {
    let text: String
    let icon: String
}
