//
//  SwiftUIView.swift
//  WeatherApp
//
//  Created by Mazen Amr on 15/06/2026.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var context
    @Query private var favorites: [FavoriteCity]
    
    @State private var isViewingSearchedCity = false
    @State private var searchedName = ""
    @State private var searchedLat = 0.0
    @State private var searchedLon = 0.0
    @State private var showCities = false
    @State private var selectedTab: String = "current_location"
    
    var isCurrentSearchFavorite: Bool {
        favorites.contains { $0.id == "\(searchedLat),\(searchedLon)" }
    }
    
    var body: some View {
        if isViewingSearchedCity {
            NavigationStack {
                WeatherPageView(lat: searchedLat, lon: searchedLon)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: { isViewingSearchedCity = false }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text("Back")
                                }.foregroundColor(.white)
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: { toggleFavorite() }) {
                                Image(systemName: isCurrentSearchFavorite ? "heart.fill" : "heart")
                                    .foregroundColor(isCurrentSearchFavorite ? .red : .white)
                                    .font(.title2)
                            }
                        }
                    }
                    .toolbarBackground(.hidden, for: .navigationBar)
            }
        } else {
            TabView(selection: $selectedTab) {
                WeatherPageView(lat: 31.2001, lon: 29.9187).tag("current_location")
                ForEach(favorites) { favorite in
                    WeatherPageView(lat: favorite.lat, lon: favorite.lon).tag(favorite.id)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .ignoresSafeArea(.all)
            .sheet(isPresented: $showCities) {
                NavigationStack {
                    CitiesView { name, lat, lon in
                        searchedName = name
                        searchedLat = lat
                        searchedLon = lon
                        isViewingSearchedCity = true
                        showCities = false
                    }
                }
            }
            .overlay(alignment: .topTrailing) {
                Button(action: { showCities = true }) {
                    Image(systemName: "list.bullet")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.top)
                }
            }
            .overlay(alignment: .topLeading) {
                if selectedTab != "current_location" {
                    Button(action: { deleteCurrentFavorite() }) {
                        Image(systemName: "trash")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .padding(.top,10)
                    }
                }
            }
        }
    }
    private func toggleFavorite() {
        if isCurrentSearchFavorite {
            if let cityToDelete = favorites.first(where: { $0.id == "\(searchedLat),\(searchedLon)" }) {
                context.delete(cityToDelete)
            }
        } else {
            let newFavorite = FavoriteCity(name: searchedName, lat: searchedLat, lon: searchedLon)
            context.insert(newFavorite)
        }
    }
    
    private func deleteCurrentFavorite() {
            if let cityToDelete = favorites.first(where: { $0.id == selectedTab }) {
                context.delete(cityToDelete)
                // selectedTab = "current_location"
            }
        }
}

#Preview {
    HomeView()
}
