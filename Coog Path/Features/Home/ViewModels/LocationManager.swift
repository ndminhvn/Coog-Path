//
//  LocationManager.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/27/23.
//

import _MapKit_SwiftUI
import Foundation
import MapKit

final class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()

    @Published var myRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 29.766083, longitude: -95.358810),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    // UH Main center coordinate
    @Published var myPosition: MapCameraPosition = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 29.72001, longitude: -95.34207), distance: 1000))
    @Published var myLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 29.72001, longitude: -95.34207)

    override init() {
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        setup()
    }

    func setup() {
        switch locationManager.authorizationStatus {
        // If we are authorized then we request location just once, to center the map
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        // If we don´t, we request authorization
        case .notDetermined:
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard .authorizedWhenInUse == manager.authorizationStatus else { return }
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong: \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()

        if let lastLocation = locations.last {
            myRegion = MKCoordinateRegion(
                center: lastLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
    }
}
