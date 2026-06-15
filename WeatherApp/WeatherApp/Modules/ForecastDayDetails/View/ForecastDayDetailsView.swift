//
//  ForecastDayDetails.swift
//  WeatherApp
//
//  Created by Mazen Amr on 15/06/2026.
//

import SwiftUI
import SDWebImageSwiftUI
struct ForecastDayDetailsView: View {
    let forecastDay: ForecastDay
    let isMorning : Bool
    @StateObject private var viewModel = ForecastDayDetailsViewModel()
    
    var body: some View {
        ZStack {
            Group {
                if let asset = NSDataAsset(name: isMorning ? "morning" : "evening") {
                    AnimatedImage(data: asset.data)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                } else {
                    Color.blue.ignoresSafeArea()
                }
            }
            
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(viewModel.filteredHours, id: \.time) { hour in
                        HStack {
                            Text(viewModel.formatTime(timeString: hour.time))
                                .font(.title3)
                                .frame(width: 80, alignment: .leading)
                                .foregroundColor(isMorning ? .black : .white)
                            
                            Spacer()
                            
                            AsyncImage(url: URL(string: "https:\(hour.condition.icon)")) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)
                            
                            Spacer()
                            
                            Text("\(Int(hour.tempC))°")
                                .font(.title2)
                                .frame(width: 60, alignment: .trailing)
                                .foregroundColor(isMorning ? .black : .white)
                        }
                        .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 20)
            }
        }
        .onAppear {
            viewModel.processHours(for: forecastDay)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(forecastDay.date)
                    .font(.headline)
                    .foregroundColor(isMorning ? .black : .white)
            }
        }
        .tint(isMorning ? .black : .white)
    }
}

//#Preview {
//    //ForecastDayDetailsView()
//}
