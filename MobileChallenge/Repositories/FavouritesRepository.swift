//
//  FavouritesRepository.swift
//  MobileChallenge
//
//  Created by Rodrigo Gras on 08/01/2026.
//

import Foundation

final class FavouritesRepository {
    private let favouritesKey = "mobile-challenge-favourites"
    
    func save(_ cityIds: Set<Int>) {
        UserDefaults.standard.set(Array(cityIds), forKey: favouritesKey)
    }
    
    func fetch() -> Set<Int> {
        let favourites = UserDefaults.standard.array(forKey: favouritesKey) as? [Int]
        return Set(favourites ?? [])
    }
}
