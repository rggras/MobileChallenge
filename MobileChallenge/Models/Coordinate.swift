//
//  Coordinate.swift
//  MobileChallenge
//
//  Created by Rodrigo Gras on 07/01/2026.
//

import Foundation

struct Coordinate: Codable, Hashable {
    let longitude: Double
    let latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}
