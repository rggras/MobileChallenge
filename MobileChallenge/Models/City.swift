//
//  City.swift
//  MobileChallenge
//
//  Created by Rodrigo Gras on 06/01/2026.
//

import Foundation

struct City: Codable {
    let id: Int
    let country: String
    let name: String
    let coordinate: Coordinate
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case country
        case name
        case coordinate = "coord"
    }
}

struct Coordinate: Codable {
    let longitude: Double
    let latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}
