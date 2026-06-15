//
//  City.swift
//  WeatherApp
//
//  Created by Mazen Amr on 16/06/2026.
//

import Foundation

struct LocalCity: Codable, Identifiable, Hashable {
    let id: String
    let city: String
    let country: String
    let lat: String
    let lng: String
    
    var latitude: Double {
        Double(lat) ?? 0.0
    }
    
    var longitude: Double {
        Double(lng) ?? 0.0
    }
}
