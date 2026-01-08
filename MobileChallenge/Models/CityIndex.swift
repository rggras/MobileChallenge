//
//  CityIndex.swift
//  MobileChallenge
//
//  Created by Rodrigo Gras on 07/01/2026.
//

import Foundation

struct CityIndex: Codable {
    let city: City
    
    var index: String {
        "\(city.name.lowercased()), \(city.country.lowercased())"
    }
}
