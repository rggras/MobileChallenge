//
//  CitiesViewModelTests.swift
//  MobileChallengeTests
//
//  Created by Rodrigo Gras on 06/01/2026.
//

import Testing
@testable import MobileChallenge

struct CitiesViewModelTests {
    @MainActor
    @Test func testSearchWithValidPrefix() async throws {
        let cities = makeTestCities()
        let service = MockCityService(cities: cities)
        let repository = MockFavouritesRepository()
        let viewModel = CitiesViewModel(cityService: service, favouritesRepository: repository)
        
        viewModel.perform(action: .onAppear)
        try await Task.sleep(nanoseconds: 200_000_000)
        
        viewModel.filterKeyword = "Al"
        viewModel.perform(action: .filter)
        
        let results = viewModel.filteredCities
        #expect(results.count == 2)
        #expect(results.contains { $0.name == "Alabama" })
        #expect(results.contains { $0.name == "Albuquerque" })
    }
    
    @MainActor
    @Test func testSearchCaseInsensitive() async throws {
        let cities = makeTestCities()
        let service = MockCityService(cities: cities)
        let repository = MockFavouritesRepository()
        let viewModel = CitiesViewModel(cityService: service, favouritesRepository: repository)
        
        viewModel.perform(action: .onAppear)
        try await Task.sleep(nanoseconds: 200_000_000)
        
        viewModel.filterKeyword = "s"
        viewModel.perform(action: .filter)
        
        let results = viewModel.filteredCities
        #expect(results.count == 1)
        #expect(results.first?.name == "Sydney")
    }
    
    @MainActor
    @Test func testSearchWithUppercase() async throws {
        let cities = makeTestCities()
        let service = MockCityService(cities: cities)
        let repository = MockFavouritesRepository()
        let viewModel = CitiesViewModel(cityService: service, favouritesRepository: repository)
        
        viewModel.perform(action: .onAppear)
        try await Task.sleep(nanoseconds: 200_000_000)
        
        viewModel.filterKeyword = "S"
        viewModel.perform(action: .filter)
        
        let results = viewModel.filteredCities
        #expect(results.count == 1)
        #expect(results.first?.name == "Sydney")
    }
    
    @MainActor
    @Test func testSearchWithInvalidPrefix() async throws {
        let cities = makeTestCities()
        let service = MockCityService(cities: cities)
        let repository = MockFavouritesRepository()
        let viewModel = CitiesViewModel(cityService: service, favouritesRepository: repository)
        
        viewModel.perform(action: .onAppear)
        try await Task.sleep(nanoseconds: 200_000_000)
        
        viewModel.filterKeyword = "XYZ"
        viewModel.perform(action: .filter)
        
        let results = viewModel.filteredCities
        #expect(results.isEmpty)
    }
    
    @MainActor
    @Test func testSearchWithEmptyString() async throws {
        let cities = makeTestCities()
        let service = MockCityService(cities: cities)
        let repository = MockFavouritesRepository()
        let viewModel = CitiesViewModel(cityService: service, favouritesRepository: repository)
        
        viewModel.perform(action: .onAppear)
        try await Task.sleep(nanoseconds: 200_000_000)
        
        viewModel.filterKeyword = ""
        viewModel.perform(action: .filter)
        
        let results = viewModel.filteredCities
        #expect(results.count == cities.count)
    }
    
    @MainActor
    @Test func testAlphabeticalOrder() async throws {
        let cities = makeTestCities()
        let service = MockCityService(cities: cities)
        let repository = MockFavouritesRepository()
        let viewModel = CitiesViewModel(cityService: service, favouritesRepository: repository)
        
        viewModel.perform(action: .onAppear)
        try await Task.sleep(nanoseconds: 200_000_000)
        
        viewModel.filterKeyword = ""
        viewModel.perform(action: .filter)
        
        let results = viewModel.filteredCities
        #expect(results.count > 1)
        
        for i in 0..<(results.count - 1) {
            let current = CityIndex(city: results[i]).index
            let next = CityIndex(city: results[i + 1]).index
            #expect(current < next)
        }
    }
    
    @MainActor
    @Test func testSearchWithSingleCharacter() async throws {
        let cities = makeTestCities()
        let service = MockCityService(cities: cities)
        let repository = MockFavouritesRepository()
        let viewModel = CitiesViewModel(cityService: service, favouritesRepository: repository)
        
        viewModel.perform(action: .onAppear)
        try await Task.sleep(nanoseconds: 200_000_000)
        
        viewModel.filterKeyword = "A"
        viewModel.perform(action: .filter)
        
        let results = viewModel.filteredCities
        #expect(results.count == 4) // Alabama, Albuquerque, Anaheim, Arizona
        #expect(!results.contains { $0.name == "Sydney" })
    }
    
    @MainActor
    @Test func testSearchWithLongerPrefix() async throws {
        let cities = makeTestCities()
        let service = MockCityService(cities: cities)
        let repository = MockFavouritesRepository()
        let viewModel = CitiesViewModel(cityService: service, favouritesRepository: repository)
        
        viewModel.perform(action: .onAppear)
        try await Task.sleep(nanoseconds: 200_000_000)
        
        viewModel.filterKeyword = "Alb"
        viewModel.perform(action: .filter)
        
        let results = viewModel.filteredCities
        #expect(results.count == 1)
        #expect(results.first?.name == "Albuquerque")
    }
    
    @MainActor
    @Test func testToggleFavourite() async throws {
        let cities = makeTestCities()
        let service = MockCityService(cities: cities)
        let repository = MockFavouritesRepository()
        let viewModel = CitiesViewModel(cityService: service, favouritesRepository: repository)
        
        viewModel.perform(action: .onAppear)
        try await Task.sleep(nanoseconds: 200_000_000)
        
        let city = cities[0]
        #expect(!viewModel.isFavourite(city))
        
        viewModel.perform(action: .toggleFavourite(city))
        #expect(viewModel.isFavourite(city))
        
        viewModel.perform(action: .toggleFavourite(city))
        #expect(!viewModel.isFavourite(city))
    }
    
    @MainActor
    @Test func testFavouriteModeFilter() async throws {
        let cities = makeTestCities()
        let service = MockCityService(cities: cities)
        let repository = MockFavouritesRepository()
        let viewModel = CitiesViewModel(cityService: service, favouritesRepository: repository)
        
        viewModel.perform(action: .onAppear)
        try await Task.sleep(nanoseconds: 200_000_000)
        
        viewModel.perform(action: .toggleFavourite(cities[0]))
        viewModel.perform(action: .toggleFavourite(cities[1]))
        viewModel.perform(action: .toggleFavouriteMode)
        
        let results = viewModel.filteredCities
        #expect(results.count == 2)
        #expect(results.contains { $0.id == cities[0].id })
        #expect(results.contains { $0.id == cities[1].id })
    }
    
    @MainActor
    @Test func testFavouriteModeWithKeyword() async throws {
        let cities = makeTestCities()
        let service = MockCityService(cities: cities)
        let repository = MockFavouritesRepository()
        let viewModel = CitiesViewModel(cityService: service, favouritesRepository: repository)
        
        viewModel.perform(action: .onAppear)
        try await Task.sleep(nanoseconds: 200_000_000)
        
        viewModel.perform(action: .toggleFavourite(cities[0])) // Alabama
        viewModel.perform(action: .toggleFavourite(cities[5])) // Denver
        viewModel.perform(action: .toggleFavouriteMode)
        viewModel.filterKeyword = "Al"
        viewModel.perform(action: .filter)
        
        let results = viewModel.filteredCities
        #expect(results.count == 1)
        #expect(results.first?.name == "Alabama")
    }
}

// MARK: - Mock Data
private extension CitiesViewModelTests {
    func makeTestCities() -> [City] {
        [
            City(id: 1, country: "US", name: "Alabama", coordinate: Coordinate(longitude: -86.8, latitude: 32.3)),
            City(id: 2, country: "US", name: "Albuquerque", coordinate: Coordinate(longitude: -106.6, latitude: 35.1)),
            City(id: 3, country: "US", name: "Anaheim", coordinate: Coordinate(longitude: -117.9, latitude: 33.8)),
            City(id: 4, country: "US", name: "Arizona", coordinate: Coordinate(longitude: -111.1, latitude: 34.0)),
            City(id: 5, country: "AU", name: "Sydney", coordinate: Coordinate(longitude: 151.2, latitude: -33.9)),
            City(id: 6, country: "US", name: "Denver", coordinate: Coordinate(longitude: -104.9, latitude: 39.7)),
            City(id: 7, country: "MX", name: "Mexico City", coordinate: Coordinate(longitude: -99.1, latitude: 19.4))
        ]
    }
}
