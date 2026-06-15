//
//  SwiftUIView.swift
//  WeatherApp
//
//  Created by Mazen Amr on 15/06/2026.
//

import SwiftUI
import SDWebImageSwiftUI
struct HomeView: View {
    var body: some View {
        VStack{
            Text("hello")
        }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
        Group {
                if let asset = NSDataAsset(name: "morning") {
                    AnimatedImage(data: asset.data)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                } else {
                    Color.black
                }
            }
            )
    }
}

#Preview {
    HomeView()
}
