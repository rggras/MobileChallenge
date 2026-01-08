//
//  CitiesView.swift
//  MobileChallenge
//
//  Created by Rodrigo Gras on 06/01/2026.
//

import SwiftUI

struct CitiesView: View {
    @StateObject private var viewModel = CitiesViewModel()
    @State private var filterKeyword = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.filteredCities) { city in
                    makeRow(from: city)
                }
            }
            .searchable(text: $filterKeyword, prompt: "Search cities")
            .navigationTitle("Cities")
            .listStyle(.plain)
            .task {
                viewModel.perform(action: .onAppear)
            }
            .task(id: filterKeyword) {
                viewModel.perform(action: .filter(filterKeyword))
            }
        }
    }
    
    private func makeRow(from city: City) -> some View {
        Text("\(city.name), \(city.country)")
    }
}

#Preview {
    CitiesView()
}
