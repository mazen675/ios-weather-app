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
                            MiddleSection(weather: weather,textColor: viewModel.textColor,formatDay: viewModel.formatDay)
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
                viewModel.fetchWeather()
            }
        }
    }
}

#Preview {
    HomeView()
}
