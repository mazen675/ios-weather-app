//
//  TopSection.swift
//  WeatherApp
//
//  Created by Mazen Amr on 15/06/2026.
//

import SwiftUI

struct TopSection: View {
    let weather: WeatherResponse
    
    var body: some View {
        VStack(spacing: 8) {
            Text(weather.location.name)
                .font(.system(size: 36, weight: .bold))
            
            Text("\(Int(weather.current.tempC))°")
                .font(.system(size: 64, weight: .thin))
            
            Text(weather.current.condition.text)
                .font(.title3)
            
            if let today = weather.forecast.forecastday.first {
                Text("H:\(Int(today.day.maxtempC))° L:\(Int(today.day.mintempC))°")
                    .font(.body)
            }
            
            AsyncImage(url: URL(string: "https:\(weather.current.condition.icon)")) { image in
                image.resizable().scaledToFit().background(Color(UIColor.white)).clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
            .frame(width: 64, height: 64)
        }
    }
}

//#Preview {
//    TopSection()
//}

