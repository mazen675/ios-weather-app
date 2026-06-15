//
//  ForecastDayWeather.swift
//  WeatherApp
//
//  Created by Mazen Amr on 15/06/2026.
//

import Foundation
struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let date: String
    let day: Day
    let hour: [Hour]
}

struct Day: Codable {
    let maxtempC: Double
    let mintempC: Double
    let condition: Condition
}

struct Hour: Codable {
    let time: String
    let tempC: Double
    let condition: Condition
}
