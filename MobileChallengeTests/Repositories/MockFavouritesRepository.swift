//
//  MockFavouritesRepository.swift
//  MobileChallengeTests
//
//  Created by Rodrigo Gras on 09/01/2026.
//

import Foundation
@testable import MobileChallenge

final class MockFavouritesRepository: FavouritesRepository {
    private var favourites: Set<Int> = []
    
    func save(_ ids: Set<Int>) {
        favourites = ids
    }
    
    func fetch() -> Set<Int> {
        return favourites
    }
}

