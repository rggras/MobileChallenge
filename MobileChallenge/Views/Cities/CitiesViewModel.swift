//
//  CitiesViewModel.swift
//  MobileChallenge
//
//  Created by Rodrigo Gras on 06/01/2026.
//

import Combine

final class CitiesViewModel: ObservableObject {
    @Published private(set) var filteredCities: [City] = []
    // TODO: In a Production code we may want to inject this
    private let cityService = CityService()
    private var indexedCities: [CityIndex] = []
    
    enum Action {
        case onAppear
        case filter(String)
    }
    
    func perform(action: Action) {
        switch action {
        case .onAppear:
            fetchCities()
        case let .filter(keyword):
            filterCities(by: keyword)
        }
    }
    
    @MainActor
    private func fetchCities() {
        Task {
            do {
                let response = try await cityService.fetchCities()
                let indices = response.map { CityIndex(city: $0) }
                indexedCities = indices.sorted { $0.index < $1.index }
                filterCities(by: "")
            } catch {
                // TODO: In a Production code we may want to handle errors
            }
        }
    }
    
    // MARK: - Filtering logic
    // TOOD: Filter by favourites
    // We are using the binary search principle to improve the filter time
    private func filterCities(by keyword: String) {
        guard !keyword.isEmpty else {
            filteredCities = indexedCities.map { $0.city }
            return
        }
        
        let lowercasedKeyword = keyword.lowercased()
        let initialIndex = firstIndex(of: lowercasedKeyword)
        // "\u{FFFF}" is a high value unicode character
        let finalIndex = firstIndex(of: lowercasedKeyword + "\u{FFFF}")

        guard initialIndex < finalIndex else {
            filteredCities = []
            return
        }
        
        filteredCities = indexedCities[initialIndex..<finalIndex].map { $0.city }
    }
    
    private func firstIndex(of keyword: String) -> Int {
        var initialIndex = 0
        var finalIndex = indexedCities.count

        while initialIndex < finalIndex {
            let middleIndex = (initialIndex + finalIndex) / 2

            if indexedCities[middleIndex].index < keyword {
                initialIndex = middleIndex + 1
            } else {
                finalIndex = middleIndex
            }
        }

        return initialIndex
    }
}
