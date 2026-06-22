//
//  WeatherPageView.swift
//  WeatherApp
//
//  Created by Mazen Amr on 23/06/2026.
//


import Foundation
import SwiftUI
import SDWebImageSwiftUI

extension ForecastDay: Identifiable {
    public var id: String { date }
}

struct WeatherPageView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    @State private var selectedDayToView: ForecastDay? = nil

    let lat: Double
    let lon: Double
    
    var body: some View {
        ZStack {
            VStack {
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if let weather = viewModel.weather {
                    ScrollView {
                        VStack(spacing: 40) {
                            TopSection(weather: weather)
                            
                            MiddleSection(
                                weather: weather,
                                textColor: viewModel.textColor,
                                formatDay: viewModel.formatDay,
                                isMorning: viewModel.isMorning,
                                onDaySelected: { tappedDay in
                                    self.selectedDayToView = tappedDay
                                }
                            )
                            
                            BottomSection(weather: weather)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical)
                        .foregroundColor(viewModel.textColor)
                    }
                } else if let error = viewModel.errorMessage {
                    Spacer()
                    Text(error).foregroundColor(.red)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Group {
                    if let asset = NSDataAsset(name: viewModel.isMorning ? "morning" : "evening") {
                        AnimatedImage(data: asset.data)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Color.blue
                    }
                }
                .ignoresSafeArea()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .onAppear {
                viewModel.fetchWeather(lat: lat, lon: lon)
            }
        }
        .fullScreenCover(item: $selectedDayToView) { forecastDay in
            ForecastDayDetailsView(
                forecastDay: forecastDay,
                isMorning: viewModel.isMorning
            )
        }
    }
}
