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
    
    @StateObject private var viewModel = HomeViewModel()
    
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
                WeatherPageView(lat: searchedLat, lon: searchedLon, fetchMode: .onlineOnly)
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
                if let loc = viewModel.currentLocation {
                    WeatherPageView(lat: loc.latitude, lon: loc.longitude, fetchMode: .offlineFirst(context)).tag("current_location")
                } else {
                    VStack {
                        ProgressView()
                        Text("Locating...").foregroundColor(.white).padding()
                    }.tag("current_location")
                }
                ForEach(favorites) { favorite in
                    WeatherPageView(lat: favorite.lat, lon: favorite.lon, fetchMode: .offlineFirst(context)).tag(favorite.id)
                }
            }       
            .alert("Offline", isPresented: $viewModel.showOfflineAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("You are not connected to the internet. Cannot search for new cities.")
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .ignoresSafeArea(.all)
            .sheet(isPresented: $showCities) {
                NavigationStack {
                    CitiesView { name, lat, lon in
                        if viewModel.isConnected {
                            viewModel.showOfflineAlert = false
                            searchedName = name
                            searchedLat = lat
                            searchedLon = lon
                            isViewingSearchedCity = true
                            showCities = false
                        } else {
                            showCities = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                viewModel.showOfflineAlert = true
                            }
                        }
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
