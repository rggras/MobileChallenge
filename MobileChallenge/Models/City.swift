//
//  City.swift
//  MobileChallenge
//
//  Created by Rodrigo Gras on 06/01/2026.
//

import Foundation

struct City: Codable, Identifiable, Hashable {
    let id: Int
    let country: String
    let name: String
    let coordinate: Coordinate
    
    var fullName: String {
        "\(name), \(country)"
    }
    
    var fullCoordinate: String {
        "\(coordinate.latitude), \(coordinate.longitude)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case country
        case name
        case coordinate = "coord"
    }
}
