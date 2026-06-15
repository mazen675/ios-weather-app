//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Mazen Amr on 15/06/2026.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let networkService = NetworkService()
    
    var isMorning: Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour >= 5 && hour < 18
    }
    
    var textColor: Color {
        return isMorning ? .black : .white
    }
    
    func fetchWeather(lat: Double = 31.2001, lon: Double = 29.9187) {
        isLoading = true
        
        networkService.fatchWeather(lat: lat, lon: lon) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.weather = data
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func formatDay(dateString: String, index: Int) -> String {
        if index == 0 { return "Today" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}
