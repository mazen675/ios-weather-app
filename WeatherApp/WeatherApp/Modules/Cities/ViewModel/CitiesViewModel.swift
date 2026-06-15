//
//  CitiesViewModel.swift
//  WeatherApp
//
//  Created by Mazen Amr on 16/06/2026.
//

import Foundation

class CitiesViewModel: ObservableObject {
    @Published var filteredCities: [LocalCity] = []
    @Published var searchText = "" {
        didSet {
            filterCities()
        }
    }
    
    private var searchWorkItem: DispatchWorkItem?
    
    init() {
        self.filteredCities = Array(Cities.prefix(50))
    }
    
    private func filterCities() {
            searchWorkItem?.cancel()
            
            let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if query.isEmpty {
                self.filteredCities = Array(Cities.prefix(50))
                return
            }
            
            var workItem: DispatchWorkItem!
            
            workItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                
                let matches = Cities.filter { city in
                    city.city.localizedCaseInsensitiveContains(query) ||
                    city.country.localizedCaseInsensitiveContains(query)
                }
                
                let limitedMatches = Array(matches.prefix(100))
                
                DispatchQueue.main.async {
                    if !workItem.isCancelled {
                        self.filteredCities = limitedMatches
                    }
                }
            }
            
            self.searchWorkItem = workItem
            DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.2, execute: workItem)
        }
}
