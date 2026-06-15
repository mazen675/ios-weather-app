//
//  SwiftUIView.swift
//  WeatherApp
//
//  Created by Mazen Amr on 15/06/2026.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var isViewingSearchedCity = false
    var body: some View {
        NavigationStack {
            ZStack {
                Group {
                    if let asset = NSDataAsset(name: viewModel.isMorning ? "morning" : "evening") {
                        AnimatedImage(data: asset.data)
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    } else {
                        Color.blue.ignoresSafeArea()
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                } else if let weather = viewModel.weather {
                    ScrollView {
                        VStack(spacing: 40) {
                            TopSection(weather: weather)
                            MiddleSection(weather: weather,textColor: viewModel.textColor,formatDay: viewModel.formatDay,isMorning: viewModel.isMorning)
                            BottomSection(weather: weather)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical)
                        .foregroundColor(viewModel.textColor)
                    }
                } else if let error = viewModel.errorMessage {
                    Text(error).foregroundColor(.red)
                }
            }
            .onAppear {
                viewModel.loadInitialWeather()
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CitiesView { selectedLat, selectedLon in
                        viewModel.fetchWeather(lat: selectedLat, lon: selectedLon)
                        isViewingSearchedCity = true
                    }) {
                        Image(systemName: "list.bullet")
                            .font(.title3)
                            .foregroundColor(viewModel.textColor)
                    }
                }
                
                if isViewingSearchedCity {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            viewModel.fetchWeather()
                            isViewingSearchedCity = false
                        }) {
                            HStack {
                                Image(systemName: "house")
                                Text("Home")
                            }
                            .foregroundColor(viewModel.textColor)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
