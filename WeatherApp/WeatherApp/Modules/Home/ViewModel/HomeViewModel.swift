//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Mazen Amr on 15/06/2026.
//

import Foundation
import SwiftUI
import CoreLocation
import SwiftData
import Network

class HomeViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var showOfflineAlert = false
    @Published var isConnected = true
    
    private var locationManager = LocationManager()
    private let monitor = NWPathMonitor()
    
    
    init() {
        locationManager.$location
            .assign(to: &$currentLocation)
        monitor.pathUpdateHandler = { [weak self] path in
                    DispatchQueue.main.async {
                        self?.isConnected = path.status == .satisfied
                    }
                }
                monitor.start(queue: DispatchQueue.global())
    }
    
    private let networkService = NetworkService()
    
    var isMorning: Bool {
        if let isDay = weather?.current.isDay {
            return isDay == 1
        }
        let hour = Calendar.current.component(.hour, from: Date())
        return hour >= 5 && hour < 18
    }
    
    var textColor: Color {
        return isMorning ? .black : .white
    }
    
    func fetchWeatherOfflineFirst(lat: Double, lon: Double, context: ModelContext) {
        let cacheId = "\(lat),\(lon)"
        
        loadFromCache(cacheId: cacheId, context: context)
        
        guard isConnected else { return }
        
        networkService.fatchWeather(lat: lat, lon: lon) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.weather = data
                    self?.saveToCache(cacheId: cacheId, data: data, context: context)
                case .failure:
                    break
                }
            }
        }
    }


    func fetchWeatherOnline(lat: Double, lon: Double) {
        guard isConnected else {
            showOfflineAlert = true
            return
        }
        
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
    
    private func saveToCache(cacheId: String, data: WeatherResponse, context: ModelContext) {
        guard let encoded = try? JSONEncoder().encode(data) else { return }
        
        let descriptor = FetchDescriptor<CachedWeather>(predicate: #Predicate { $0.id == cacheId })
        if let existing = try? context.fetch(descriptor).first {
            existing.weatherData = encoded
        } else {
            context.insert(CachedWeather(id: cacheId, weatherData: encoded))
        }
        try? context.save()
    }
    
    private func loadFromCache(cacheId: String, context: ModelContext) {
        let descriptor = FetchDescriptor<CachedWeather>(predicate: #Predicate { $0.id == cacheId })
        
        if let cached = try? context.fetch(descriptor).first,
           let decoded = try? JSONDecoder().decode(WeatherResponse.self, from: cached.weatherData) {
            self.weather = decoded
            self.errorMessage = nil
        } else {
            self.errorMessage = isConnected ? nil : "No cached data available."
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
