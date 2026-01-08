//
//  CityDetailView.swift
//  MobileChallenge
//
//  Created by Rodrigo Gras on 08/01/2026.
//

import SwiftUI

struct CityDetailView: View {
    let city: City
    
    var body: some View {
        List {
            makeRow(title: "Id", value: String(city.id))
            makeRow(title: "Country", value: city.country)
            makeRow(title: "Name", value: city.name)
            makeRow(title: "Latitude", value: String(city.coordinate.latitude))
            makeRow(title: "Longitude", value: String(city.coordinate.longitude))
        }
        .navigationTitle(city.fullName)
    }
    
    private func makeRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .fontWeight(.medium)
            Spacer()
            Text(value)
        }
    }
}
