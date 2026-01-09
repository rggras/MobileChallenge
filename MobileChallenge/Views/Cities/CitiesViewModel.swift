//
//  CitiesViewModel.swift
//  MobileChallenge
//
//  Created by Rodrigo Gras on 06/01/2026.
//

import Combine

final class CitiesViewModel: ObservableObject {
    @Published private(set) var filteredCities: [City] = []
    @Published private(set) var favouriteCityIds: Set<Int> = []
    @Published private(set) var isFavouriteModeEnabled = false
    @Published var filterKeyword = ""
    private let cityService: CityService
    private let favouritesRepository: FavouritesRepository
    private var indexedCities: [CityIndex] = []
    
    enum Action {
        case onAppear
        case filter
        case toggleFavourite(City)
        case toggleFavouriteMode
    }
    
    init(
        cityService: CityService = RemoteCityService(),
        favouritesRepository: FavouritesRepository = UserDefaultsFavouritesRepository()
    ) {
        self.cityService = cityService
        self.favouritesRepository = favouritesRepository
        favouriteCityIds = favouritesRepository.fetch()
    }
    
    func perform(action: Action) {
        switch action {
        case .onAppear:
            fetchCities()
        case .filter:
            filterCities()
        case let .toggleFavourite(city):
            toggleFavourite(for: city)
        case .toggleFavouriteMode:
            toggleFavouriteMode()
        }
    }
    
    @MainActor
    private func fetchCities() {
        guard indexedCities.isEmpty else { return }
        
        // TODO: In a Production code we may want to add a loading state here
        
        Task {
            do {
                let response = try await cityService.fetchCities()
                let indices = response.map { CityIndex(city: $0) }
                indexedCities = indices.sorted { $0.index < $1.index }
                filterCities()
            } catch {
                // TODO: In a Production code we may want to handle errors
            }
        }
    }
    
    // MARK: - Favourite logic
    private func toggleFavouriteMode() {
        isFavouriteModeEnabled.toggle()
        filterCities()
    }
    
    private func toggleFavourite(for city: City) {
        if favouriteCityIds.contains(city.id) {
            favouriteCityIds.remove(city.id)
        } else {
            favouriteCityIds.insert(city.id)
        }
        
        favouritesRepository.save(favouriteCityIds)
        filterCities()
    }
    
    func isFavourite(_ city: City) -> Bool {
        favouriteCityIds.contains(city.id)
    }
    
    // MARK: - Filtering logic
    private func filterCities() {
        let cities = filterCitiesByPrefix()
        
        guard !isFavouriteModeEnabled else {
            if !filterKeyword.isEmpty {
                filteredCities = cities
                    .filter { favouriteCityIds.contains($0.id) }
            } else {
                filteredCities = favouriteCityIds
                    .compactMap { id in indexedCities.first { $0.city.id == id }?.city }
            }
            return
        }
        
        filteredCities = cities
    }
    
    private func filterCitiesByPrefix() -> [City] {
        guard !filterKeyword.isEmpty else {
            return indexedCities.map { $0.city }
        }
        
        let lowercasedKeyword = filterKeyword.lowercased()
        let initialIndex = firstIndex(of: lowercasedKeyword)
        // "\u{FFFF}" is a high value unicode character
        let finalIndex = firstIndex(of: lowercasedKeyword + "\u{FFFF}")

        guard initialIndex < finalIndex else {
            return []
        }
        
        return indexedCities[initialIndex..<finalIndex].map { $0.city }
    }
    
    // We are using the binary search principle to improve the filter time
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
