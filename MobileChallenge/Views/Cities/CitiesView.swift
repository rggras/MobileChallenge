//
//  CitiesView.swift
//  MobileChallenge
//
//  Created by Rodrigo Gras on 06/01/2026.
//

import SwiftUI

struct CitiesView: View {
    @StateObject private var viewModel = CitiesViewModel()
    @State private var navigationPath = NavigationPath()
    @State private var isPortrait = true
    @State private var selectedCity: City?
    
    private enum Route: Hashable {
        case detail(_ city: City)
        case map(_ city: City)
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            content
            .navigationTitle("Cities")
            .navigationDestination(for: Route.self) { route in
                switch route {
                case let .detail(city: city):
                    CityDetailView(city: city)
                case let .map(city: city):
                    CityMapView(city: .constant(city))
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.perform(action: .toggleFavouriteMode)
                    } label: {
                        Image(systemName: viewModel.isFavouriteModeEnabled ? "heart.fill" : "heart")
                    }
                }
            }
            .searchable(text: $viewModel.filterKeyword, prompt: "Search cities")
            .listStyle(.plain)
            .task {
                viewModel.perform(action: .onAppear)
            }
            .task(id: viewModel.filterKeyword) {
                viewModel.perform(action: .filter)
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        GeometryReader { geometry in
            let portrait = geometry.size.width < geometry.size.height
            
            if isPortrait {
                citiesListView
            } else {
                HStack {
                    citiesListView
                    CityMapView(city: $selectedCity)
                }
            }
            
            Color.clear
                .onAppear {
                    isPortrait = portrait
                }
                .onChange(of: geometry.size) { _, _ in
                    isPortrait = geometry.size.width < geometry.size.height
                }
        }
    }
    
    private var citiesListView: some View {
        List {
            ForEach(viewModel.filteredCities) { city in
                makeRow(from: city)
            }
        }
    }
    
    private func makeRow(from city: City) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(city.fullName)
                    .font(.body)
                Text(city.fullCoordinate)
                    .font(.caption)
            }
            
            Spacer()
            
            Button {
                viewModel.perform(action: .toggleFavourite(city))
            } label: {
                Image(systemName: viewModel.isFavourite(city) ? "heart.fill" : "heart")
            }
            .buttonStyle(.plain)
            
            Button {
                navigationPath.append(Route.detail(city))
            } label: {
                Image(systemName: "info.circle")
            }
            .buttonStyle(.plain)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            selectedCity = city
            if isPortrait {
                navigationPath.append(Route.map(city))
            }
        }
    }
}

#Preview {
    CitiesView()
}
