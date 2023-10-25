//
//  HomeScreen.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/20/23.
//

import SwiftUI
import MapKit



struct HomeScreen: View {
    @State private var fromLocation: String = ""
    @State private var toLocation: String = ""
    @State private var hiddenButton: Bool = true
//    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: 29.766083, longitude: -95.358810),
//            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        ))
    
    @StateObject var manager = LocationManager()
    

    //var locationManager:  CLLocationManager?
    
    
    var body: some View {
        VStack {
            //Title
            HStack {
                Text("Coog Path")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            Spacer()
            
            //From stack
            VStack {
                HStack{
                    Text("From")
                        .bold()
                        .font(.system(size:20))
                    Spacer()
                }
                TextField(
                    "Your Current Location",
                    text: $fromLocation
                )
                .textFieldStyle(.roundedBorder)
                
            }
            
            //Going to stack
            VStack{
                HStack{
                    Text("Going to")
                        .bold()
                        .font(.system(size:20))
                    Spacer()
                }
                
                TextField(
                    "Search building",
                    text: $toLocation
                )
                .textFieldStyle(.roundedBorder)
            }
            .padding(.bottom)
            Spacer()
            
            //Map stack
            VStack{
                
                
                Map(position: $manager.region) {
                    UserAnnotation()
                }
                
                    .clipShape(.rect(cornerRadius: 16))
                    
            }
            
            Spacer()
            Spacer()
            //Red button
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Go Coog")
                    .font(.title2)
                    .bold()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    .padding(.horizontal,20)
                    .foregroundStyle(.white)
             
            })
            .background(RoundedRectangle(cornerRadius: 16).fill(Color("MainColor")))
            Spacer()
        }
        .padding()
    }
}

final class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var region = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 29.766083, longitude: -95.358810),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.setup()
    }
    
    func setup() {
        switch locationManager.authorizationStatus {
        //If we are authorized then we request location just once, to center the map
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        //If we don´t, we request authorization
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
        locations.last.map {
            region = MapCameraPosition.region(MKCoordinateRegion(
                center: $0.coordinate,
                span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
        }
    }
}




//extension CLLocationCoordinate2D{
//    static var userLocation: CLLocationCoordinate2D{
//        return .init(latitude: 29.766083, longitude: -95.358810)
//    }
//}
//
//extension MKCoordinateRegion{
//    static var userRegion: MKCoordinateRegion{
//        return .init(center: .userLocation,
//                     latitudinalMeters:1000,
//                     longitudinalMeters:1000)
//    }
//}

#Preview {
    HomeScreen()
}
