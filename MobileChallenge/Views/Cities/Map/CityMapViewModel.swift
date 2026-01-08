//
//  CityMapViewModel.swift
//  MobileChallenge
//
//  Created by Rodrigo Gras on 08/01/2026.
//

import Combine
import SwiftUI
import MapKit

final class CityMapViewModel: ObservableObject {
    @Published var position: MapCameraPosition
    private let city: City?
    
    var markerTitle: String {
        city?.fullName ?? ""
    }
    
    var markerLocation: CLLocationCoordinate2D? {
        guard let city else {
            return nil
        }
        
        return CityMapViewModel.getLocation(from: city)
    }
    
    init(city: City?) {
        self.city = city
        self.position = .region(
            MKCoordinateRegion(
                center: CityMapViewModel.getLocation(from: city),
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.01)
            )
        )
    }
    
    private static func getLocation(from city: City?) -> CLLocationCoordinate2D {
        guard let city else {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        
        return CLLocationCoordinate2D(
            latitude: city.coordinate.longitude,
            longitude: city.coordinate.latitude
        )
    }
}
