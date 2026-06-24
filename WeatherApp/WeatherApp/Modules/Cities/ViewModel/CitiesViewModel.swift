//
//  CitiesViewModel.swift
//  WeatherApp
//
//  Created by Mazen Amr on 16/06/2026.
//
import Foundation
import Combine

class CitiesViewModel: ObservableObject {
    @Published var filteredCities: [LocalCity] = []
    @Published var searchText = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.filteredCities = Array(Cities.prefix(50))
        setupSearchPublisher()
    }
    
    private func setupSearchPublisher() {
        $searchText
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.global(qos: .userInteractive))
            .map { query -> [LocalCity] in
                let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if trimmed.isEmpty {
                    return Array(Cities.prefix(50))
                }
                
                let matches = Cities.filter { city in
                    city.city.localizedCaseInsensitiveContains(trimmed) ||
                    city.country.localizedCaseInsensitiveContains(trimmed)
                }
                
                return Array(matches.prefix(100))
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$filteredCities) 
    }
}
