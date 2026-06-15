//
//  CitiesView.swift
//  WeatherApp
//
//  Created by Mazen Amr on 15/06/2026.
//

import SwiftUI

struct CitiesView: View {
    @StateObject private var viewModel = CitiesViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var onCitySelected: ((Double, Double) -> Void)
    
    var body: some View {
        List(viewModel.filteredCities) { localCity in
            Button(action: {
                onCitySelected(localCity.latitude, localCity.longitude)
                
                dismiss()
            }) {
                VStack(alignment: .leading) {
                    Text(localCity.city)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    Text(localCity.country)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Saved Locations")
        .searchable(text: $viewModel.searchText, prompt: "Search for a city globally")
    }
}
//#Preview {
//    CitiesView()
//}
