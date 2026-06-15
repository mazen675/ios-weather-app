//
//  ForecastDayViewModel.swift
//  WeatherApp
//
//  Created by Mazen Amr on 15/06/2026.
//

import Foundation
import SwiftUI

class ForecastDayDetailsViewModel: ObservableObject {
    @Published var filteredHours: [Hour] = []
    
    func processHours(for forecastDay: ForecastDay) {
        let now = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: now)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: now)
        
        if forecastDay.date == todayString {
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            filteredHours = forecastDay.hour.filter { hourObj in
                if let hourDate = formatter.date(from: hourObj.time) {
                    return calendar.component(.hour, from: hourDate) >= currentHour
                }
                return true
            }
        } else {
            filteredHours = forecastDay.hour
        }
    }
    
    func formatTime(timeString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        guard let date = formatter.date(from: timeString) else { return timeString }
        
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) && calendar.component(.hour, from: date) == calendar.component(.hour, from: Date()) {
            return "Now"
        }
        
        formatter.dateFormat = "h a"
        return formatter.string(from: date)
    }
}
