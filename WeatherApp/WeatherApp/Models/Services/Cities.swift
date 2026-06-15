//
//  Cities.swift
//  WeatherApp
//
//  Created by Mazen Amr on 16/06/2026.
//

import Foundation
var Cities : [LocalCity] =  load("cities.json")

func load<T : Decodable> (_ filename :String) -> T{
    var data: Data
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("couldn't open file")
    }
    do{
        data = try Data(contentsOf: file)
    }catch{
        fatalError("couldn't open file")
    }
    do {
        return try JSONDecoder().decode(T.self, from: data)
    }catch{
        fatalError("couldn't open file")
    }
}
