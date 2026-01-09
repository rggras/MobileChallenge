//
//  MockCityService.swift
//  MobileChallengeTests
//
//  Created by Rodrigo Gras on 09/01/2026.
//

import Foundation
@testable import MobileChallenge

final class MockCityService: CityService {
    let cities: [City]
    
    init(cities: [City]) {
        self.cities = cities
    }
    
    func fetchCities() async throws -> [City] {
        return cities
    }
}

