//
//  CityService.swift
//  MobileChallenge
//
//  Created by Rodrigo Gras on 06/01/2026.
//

import Foundation

protocol CityService {
    func fetchCities() async throws -> [City]
}

final class RemoteCityService: CityService {
    
    // TODO: In a Production code we may want to handle urls in a smart way
    private let fetchCitiesUrl = URL(string: "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json")!
    
    // TODO: In a Production code we may want to handle fetch errors
    func fetchCities() async throws -> [City] {
        let (data, _) = try await URLSession.shared.data(from: fetchCitiesUrl)
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode([City].self, from: data)
    }
}
