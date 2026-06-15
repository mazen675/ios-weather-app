//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Mazen Amr on 15/06/2026.
//

import Foundation

class NetworkService {
    let key = "87215d7f56ba4bcba1b50138252504"
    let baseURL = "https://api.weatherapi.com/v1"
    func fatchWeather(lat:  Double , lon: Double ,completion : @escaping (Result<WeatherResponse, Error>) -> Void ){
        guard let url = URL(string: "\(baseURL)/forecast.json?key=\(key)&q=\(lat),\(lon)&days=3&aqi=yes&alerts=no") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else { return }
                
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let response = try decoder.decode(WeatherResponse.self, from: data)
                completion(.success(response))
            } catch {
                if let decodingError = error as? DecodingError {
                    print("❌ DECODING ERROR: \(decodingError)")
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("🌍 RAW JSON: \(jsonString)")
                }
                completion(.failure(error))
            }
          }
          task.resume()
    }
}
