//
//  FavouritesRepository.swift
//  MobileChallenge
//
//  Created by Rodrigo Gras on 08/01/2026.
//

import Foundation

protocol FavouritesRepository {
    func save(_ ids: Set<Int>)
    func fetch() -> Set<Int>
}

final class UserDefaultsFavouritesRepository: FavouritesRepository {
    private let favouritesKey = "mobile-challenge-favourites"
    
    func save(_ ids: Set<Int>) {
        UserDefaults.standard.set(Array(ids), forKey: favouritesKey)
    }
    
    func fetch() -> Set<Int> {
        let favourites = UserDefaults.standard.array(forKey: favouritesKey) as? [Int]
        return Set(favourites ?? [])
    }
}
