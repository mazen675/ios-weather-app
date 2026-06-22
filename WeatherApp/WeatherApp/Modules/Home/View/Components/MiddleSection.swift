//
//  MiddleSection.swift
//  WeatherApp
//
//  Created by Mazen Amr on 15/06/2026.
//

import SwiftUI
import SDWebImageSwiftUI

struct MiddleSection: View {
    let weather: WeatherResponse
    let textColor: Color
    let formatDay: (String, Int) -> String
    let isMorning: Bool
    
    let onDaySelected: (ForecastDay) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("3-DAY FORECAST")
                .font(.caption)
                .opacity(0.8)
            
            Divider().background(textColor)
            
            ForEach(Array(weather.forecast.forecastday.enumerated()), id: \.element.date) { index, day in
                Button(action: {
                    onDaySelected(day)
                }) {
                    HStack {
                        Text(formatDay(day.date, index))
                            .frame(width: 80, alignment: .leading)
                        
                        Spacer()
                        
                        WebImage(url: URL(string: "https:\(day.day.condition.icon)"))
                            .resizable()
                            .indicator(.progress)
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        
                        Spacer()
                        
                        Text("\(day.day.mintempC, specifier: "%.1f")° - \(day.day.maxtempC, specifier: "%.1f")°")
                            .frame(width: 100, alignment: .trailing)
                    }
                    .padding(.vertical, 8)
                    .foregroundColor(textColor)
                }
                Divider().background(textColor)
            }
        }
    }
}
