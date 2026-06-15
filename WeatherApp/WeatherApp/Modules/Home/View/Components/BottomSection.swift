//
//  BottomSection.swift
//  WeatherApp
//
//  Created by Mazen Amr on 15/06/2026.
//

import SwiftUI

struct BottomSection: View {
    let weather: WeatherResponse
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                weatherDataCell(title: "VISIBILITY", value: "10 km")
                weatherDataCell(title: "HUMIDITY", value: "\(weather.current.humidity)%")
            }
            HStack {
                weatherDataCell(title: "FEELS LIKE", value: "\(Int(weather.current.feelslikeC ?? 0.0))°")
                weatherDataCell(title: "PRESSURE", value: "\(Int(weather.current.pressureMb ?? 0))")
            }
        }
    }
    
    private func weatherDataCell(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .opacity(0.8)
            Text(value)
                .font(.title2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//#Preview {
//    BottomSection()
//}
