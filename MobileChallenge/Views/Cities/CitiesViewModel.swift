//
//  CitiesViewModel.swift
//  MobileChallenge
//
//  Created by Rodrigo Gras on 06/01/2026.
//

import Combine

final class CitiesViewModel: ObservableObject {
    @Published var cities: [City] = []
    
    @MainActor
    private func fetchCities() {
        
    }
}
