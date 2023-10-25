//
//  LocationManager.swift
//  Coog Path
//
//  Created by Steven Duong on 10/22/23.
//

import MapKit
import CoreLocation

class LocationManager: NSObject {
    

    class CLLocationManagerDelegate{
        
    }
    class ObservableObject{
        
    }
    @Published var region = MKCoordinateRegion()

    private let manager = CLLocationManager()
    
    override init() {
            super.init()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
    }
    .startUpdatingLocation()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            locations.last.map {
                region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                )
            }
        }
}

