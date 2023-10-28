//
//  HomeScreen.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/20/23.
//

import MapKit
import SwiftUI

struct HomeScreen: View {
    @State private var fromLocation: String = ""
    @State private var toLocation: String = ""
    @Namespace var mapScope

    @StateObject var manager = LocationManager()

    var body: some View {
        VStack {
            // Title
            HStack {
                Text("Coog Path")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            Spacer()

            // Map stack
            Map(position: $manager.position, scope: mapScope) {
                Marker("UH", coordinate: CLLocationCoordinate2D(latitude: 29.72001, longitude: -95.34207))
                UserAnnotation()
            }
            .overlay(alignment: .topLeading) {
                VStack {
                    // From stack
                    VStack {
                        HStack {
                            Text("From")
                                .bold()
                                .font(.system(size: 20))
                            Spacer()
                        }
                        TextField(
                            "Your Current Location",
                            text: $fromLocation
                        )
                        .textFieldStyle(.roundedBorder)
                    }
                    .shadow(radius: 10)

                    // Going to stack
                    VStack {
                        HStack {
                            Text("Going to")
                                .bold()
                                .font(.system(size: 20))

                            Spacer()
                        }

                        TextField(
                            "Search building",
                            text: $toLocation
                        )
                        .textFieldStyle(.roundedBorder)
                    }
                    .shadow(radius: 10)
                }
                .padding()
                .background(Color.white.opacity(0.75).blur(radius: 4))
            }
            .overlay(alignment: .bottomTrailing) {
                VStack {
                    MapUserLocationButton(scope: mapScope)
                    MapPitchToggle(scope: mapScope)
                    MapCompass(scope: mapScope)
                        .mapControlVisibility(.visible)
                }
                .padding()
                .buttonBorderShape(.circle)
            }
            .mapScope(mapScope)
            .onChange(of: toLocation) {
                manager.position = .automatic
            }
            .clipShape(.rect(cornerRadius: 16))
            
            // Red button
            // NOTE: Display the button based on value of destination box - TEMPORARY.
            // TODO: Display the button if find a valid destination.
            if !toLocation.isEmpty {
                Button(action: {}, label: {
                    Text("Go Coog")
                        .font(.title2)
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                        .padding(.horizontal, 20)
                        .foregroundStyle(.white)

                })
                .background(RoundedRectangle(cornerRadius: 16).fill(Color("MainColor")))
            }
        }
        .padding()
    }
}

#Preview {
    HomeScreen()
}
