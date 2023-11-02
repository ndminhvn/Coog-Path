//
//  HomeScreen.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/20/23.
//

import MapKit
import SwiftUI

struct HomeScreen: View {
    
    //Search text field properties
    @State private var fromLocation: String = ""
    @State private var destinationLocation: String = "" // Destination
    @State private var searchResults: [MKMapItem] = []
    @FocusState private var isFocused: Bool // If text field is focused
    // Map properties
    @Namespace var mapScope
    @StateObject var locationManager = LocationManager()
    @ObservedObject var buildingVM = BuildingViewModel()
    // Route properties
    @State private var routeDisplaying: Bool = false
    @State private var route: MKRoute?
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
            Map(position: $locationManager.myPosition, scope: mapScope) {
//                Marker("UH", coordinate: CLLocationCoordinate2D(latitude: 29.72001, longitude: -95.34207))
                ForEach(buildingVM.searchResults, id: \.self){ mapItem in
                    let placemark = mapItem.placemark
                    Marker(destinationLocation, coordinate: placemark.coordinate)
                        .tint(Color("MainColor"))
                }
                //Display route using polyline
                if !isFocused, let route{
                    MapPolyline(route.polyline)
                        .stroke(Color("MainColor"), lineWidth:7)
                }
                
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
                    }

                    // Going to stack
                    VStack {
    
                        HStack {
                            Text("Going to")
                                .bold()
                                .font(.system(size: 20))
                            Spacer()
                        }
                        
                        // Search building text field
                        HStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .opacity(0.5)
                                TextField(
                                    "Search building",
                                    text: $buildingVM.searchDestinationForMap
                                )
                                .focused($isFocused)
                                .textFieldStyle(.plain)
//                                .onSubmit {
//                                    // dismiss list
//                                    // trigger search function
//                                    // show marker on map
//                                    // show let's run button
//                                    isFocused = false
//                                    print(buildingVM.filteredBuildingsForMap)
//                                    Task{
//                                        guard !buildingVM.searchDestinationForMap.isEmpty else {return}
//                                        await buildingVM.searchBuilding()
//                                    }
//                                }
                                
                                // Dismiss search list when user click x symbol
                                if !buildingVM.searchDestinationForMap.isEmpty && isFocused {
                                    Button {
                                        buildingVM.searchDestinationForMap = ""
                                        route = nil
                                        isFocused.toggle()
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                    }
                                }
                                
                                // Dismiss seach list when user click "cancel" button
                                if !buildingVM.searchDestinationForMap.isEmpty && isFocused {
                                    Button {
                                        buildingVM.searchDestinationForMap = ""
                                        route = nil
                                        isFocused.toggle()
                                    } label: {
                                        Text("Cancel")
                                    }
                                }
                            }
                            .padding(7)
                            .background(Color.white)
                            .clipShape(.rect(cornerRadius: 6))
                        }
                        
                        // Show list of valid building name
                        if !buildingVM.searchDestinationForMap.isEmpty && isFocused {
                            List {
                                ForEach(buildingVM.filteredBuildingsForMap) { building in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(building.Abbr)
                                                .bold()
                                                .font(.system(size: 20))
                                            Text(building.Name)
                                                .font(.system(size: 15))
                                        }
                                        Spacer()
                                    }
                                    //When user pick a destination building
                                    .onTapGesture {
                                        buildingVM.searchDestinationForMap = building.Name
                                        isFocused = false
                                        destinationLocation = buildingVM.searchDestinationForMap
                                        Task{
                                            guard !buildingVM.searchDestinationForMap.isEmpty else {return}
                                            await buildingVM.searchBuilding() //Place marker
                                            route = await buildingVM.fetchRoute() //Show polyline
                                            withAnimation(.snappy){
                                                routeDisplaying = true
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(maxHeight: 250)
                            .listStyle(.plain)
                            .onAppear {
                                Task {
                                    buildingVM.loadData()
                                }
                            }
                        }
                    }
                }
                .textFieldStyle(.roundedBorder)
                .shadow(radius: 10)
                .padding()
                .background(Color.white.opacity(0.75).blur(radius: 4))
            }
            // Map control
            .overlay(alignment: .bottomTrailing) {
                if !isFocused {
                    VStack {
                        MapUserLocationButton(scope: mapScope)
                        MapPitchToggle(scope: mapScope)
                        MapCompass(scope: mapScope)
                            .mapControlVisibility(.automatic)
                    }
                    .buttonBorderShape(.roundedRectangle)
                    .padding()
                }
            }
            .mapScope(mapScope)
            // Add map selection to show building detail when user click on marker
            .onChange(of: destinationLocation) {
                locationManager.myPosition = .automatic
            }
            .clipShape(.rect(cornerRadius: 16))

            // Display the button if find a valid destination.
            if !destinationLocation.isEmpty && destinationLocation == buildingVM.searchDestinationForMap {
                Button(action: {
                    print("Button clicked")
                }, label: {
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
