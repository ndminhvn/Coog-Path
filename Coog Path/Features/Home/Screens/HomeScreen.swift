//
//  HomeScreen.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/20/23.
//

import MapKit
import SwiftUI

struct HomeScreen: View {
    // Search text field properties
    @State private var destinationLocation: String = "" // Destination
    @State private var searchResults: MKMapItem?
    @FocusState private var isFocused: Bool // If text field is focused
    // Map properties
    @Namespace var mapScope
    @StateObject var locationManager = LocationManager()
    @ObservedObject var buildingVM = BuildingViewModel()
    // Route properties
    @State private var routeDisplaying: Bool = false
    @State private var route: MKRoute?
    // Map detail properties
    @State private var showDetails = false
    @State private var lookAroundScene: MKLookAroundScene?

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
                ForEach(buildingVM.searchResults, id: \.self) { mapItem in
                    let placemark = mapItem.placemark
                    Marker(destinationLocation, coordinate: placemark.coordinate)
                        .tint(Color.main)
                }

                UserAnnotation() // User location
                // Display route using polyline
                if let route {
                    MapPolyline(route.polyline)
                        .stroke(.main, lineWidth: 7)
                }
            }
            .overlay(alignment: .topLeading) {
                VStack {
                    // From stack
//                    VStack {
//                        HStack {
//                            Text("From")
//                                .bold()
//                                .font(.system(size: 20))
//                            Spacer()
//                        }
//                        TextField(
//                            "Your Current Location",
//                            text: $fromLocation
//                        )
//                    }

                    // Going to stack
                    VStack {
                        if !routeDisplaying {
                            HStack {
                                Text("Destination")
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

                                    // Dismiss search list when user click x symbol
                                    if !buildingVM.searchDestinationForMap.isEmpty && isFocused {
                                        Button {
                                            buildingVM.searchDestinationForMap = "" // Empty search bar
                                            buildingVM.removeSearchResults() // Remove all results
                                            searchResults = nil // search result for detail preview
                                            route = nil // empty route
                                            isFocused.toggle() // unfocus
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                        }
                                    }
                                }
                                .padding(7)
                                .background(Color.white)
                                .clipShape(.rect(cornerRadius: 6))
                                // Dismiss seach list when user click "cancel" button
                                if !buildingVM.searchDestinationForMap.isEmpty && isFocused {
                                    Button {
                                        buildingVM.searchDestinationForMap = "" // Empty search bar
                                        buildingVM.removeSearchResults() // Remove all results
                                        searchResults = nil // search result for detail preview
                                        route = nil // empty route
                                        isFocused.toggle() // unfocus

                                    } label: {
                                        Text("Cancel")
                                    }
                                }
                            }
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

                                    // When user pick a destination building
                                    .onTapGesture {
                                        buildingVM.searchDestinationForMap = building.Name
                                        isFocused = false
                                        destinationLocation = buildingVM.searchDestinationForMap
                                        Task {
                                            guard !buildingVM.searchDestinationForMap.isEmpty else { return }
                                            await buildingVM.searchBuilding() // Await for search building to add building location to searchResult
                                            searchResults = buildingVM.searchResults[0]
                                            // Show polyline
//                                            route = await buildingVM.fetchRoute()
//                                            withAnimation(.snappy) {
//                                                routeDisplaying = true
//                                            }
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
                // If search box not focus display map compass
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
            // Show building detail when user select a building
            .sheet(isPresented: $showDetails, content: {
                MapDetails()
                    .presentationDetents([.height(300)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(300)))
                    .presentationCornerRadius(25)
                    .interactiveDismissDisabled(true)
            })
            // End route button
            .safeAreaInset(edge: .bottom) {
                if routeDisplaying {
                    Button(action: {
                        withAnimation(.snappy) {
                            routeDisplaying = false
                            showDetails = true
                            searchResults = buildingVM.searchResults[0]
                            route = nil
                        }
                    }, label: {
                        Text("End Route")
                            .font(.title2)
                            .bold()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 45)
                            .padding(.horizontal, 20)
                            .foregroundStyle(.white)
                    })
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.main))
                }
            }
            .onChange(of: searchResults) { _, newValue in
                // locationManager.myPosition = .automatic
                // Show preview detail if user pick a location
                // showDetails = searchResults != nil ? true : false
                showDetails = newValue != nil
                fetchLookAroundPreview()
            }
            .clipShape(.rect(cornerRadius: 16))
        }
        .padding()
        .background(Color.background)
    }

    // Fetching location preview
    func fetchLookAroundPreview() {
        if let searchResults = searchResults {
            lookAroundScene = nil
            Task {
                do {
                    let request = MKLookAroundSceneRequest(mapItem: searchResults)
                    lookAroundScene = try await request.scene
                    print("success")
                } catch {
                    // Handle the error here
                    print("Error fetching look around preview: \(error)")
                }
            }
        } else {
            // Handle the case where searchResults is nil
            print("Error: searchResults is nil")
        }
    }

    // Map Details View
    @ViewBuilder
    func MapDetails() -> some View {
        VStack(spacing: 15) {
            ZStack {
                if lookAroundScene == nil {
                    ContentUnavailableView("No Preview Available", systemImage: "eye.slash")
                } else {
                    LookAroundPreview(initialScene: lookAroundScene)
                }
            }
            .frame(height: 200)
            .clipShape(.rect(cornerRadius: 15))
            // close button for location preview
            .overlay(alignment: .topTrailing) {
                Button(action: {
                    buildingVM.searchDestinationForMap = "" // Empty search bar
                    buildingVM.removeSearchResults() // Remove all results
                    searchResults = nil // search result for detail preview
                    route = nil // remove route
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(.black)
                        .background(.white, in: .circle)
                })
                .padding(10)
            }

            // Direction's button
            Button(action: {
                Task {
                    route = await buildingVM.fetchRoute()
                    withAnimation(.snappy) {
                        routeDisplaying = true
                    }
                }
                // hide location preview
                print("hello")
                showDetails = false
            }, label: {
                Text("Go Coog")
                    .font(.title2)
                    .bold()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 45)
                    .padding(.horizontal, 20)
                    .foregroundStyle(.white)
            })
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.main))
        }
        .padding(15)
    }
}

#Preview {
    HomeScreen()
}
