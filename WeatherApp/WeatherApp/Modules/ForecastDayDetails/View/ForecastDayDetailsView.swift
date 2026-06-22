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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
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
                }
            }
            .padding(.horizontal, 32)
            .padding(.top ,50)
            .padding(.bottom, 20)
        }
        .background {
            Group {
                if let asset = NSDataAsset(name: isMorning ? "morning" : "evening") {
                    AnimatedImage(data: asset.data)
                        .resizable()
                        .scaledToFill()
                } else {
                    Color.blue
                }
            }
            .ignoresSafeArea()
        }
        .onAppear {
            viewModel.processHours(for: forecastDay)
        }
        .navigationBarHidden(true)
        .overlay(alignment: .top) {
            HStack {

                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                
                Spacer()

                Text(forecastDay.date)
                    .font(.headline)
                
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .opacity(0)
            }
            .foregroundColor(isMorning ? .black : .white)
            .padding(.horizontal, 16)
            .padding(.top, 10)
        }
    }
}
