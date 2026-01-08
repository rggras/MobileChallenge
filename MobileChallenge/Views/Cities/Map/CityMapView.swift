//
//  CityMapView.swift
//  MobileChallenge
//
//  Created by Rodrigo Gras on 08/01/2026.
//

import SwiftUI
import MapKit

struct CityMapView: View {
    @Binding var city: City?
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(center: defaultLocation, span: defaultSpan)
    )
    
    private static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    private static let defaultLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var body: some View {
        Map(position: $position) {
            Marker(
                city?.fullName ?? "",
                coordinate: location(for: city)
            )
        }
        .onAppear(perform: updatePosition)
        .onChange(of: city) { _, _ in
            updatePosition()
        }
    }
    
    private func location(for city: City?) -> CLLocationCoordinate2D {
        guard let city else {
            return Self.defaultLocation
        }
        
        return CLLocationCoordinate2D(
            latitude: city.coordinate.latitude,
            longitude: city.coordinate.longitude
        )
    }
    
    private func region(for city: City?) -> MKCoordinateRegion {
        MKCoordinateRegion(
            center: location(for: city),
            span: Self.defaultSpan
        )
    }
    
    private func updatePosition() {
        position = .region(region(for: city))
    }
}
