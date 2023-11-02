//
//  BuildingViewModel.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/21/23.
//

import Foundation
import MapKit
import SwiftUI

class BuildingViewModel: ObservableObject {
    @Published var buildings = [Building]()
    @Published var searchText: String = ""
    @Published var searchDestinationForMap: String = ""
    @Published var searchResults: [MKMapItem] = []
    @StateObject var locationManager = LocationManager()
    func loadData() {
        if let url = Bundle.main.url(forResource: "building_list", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let buildings = try JSONDecoder().decode([Building].self, from: data)
                DispatchQueue.main.async {
                    self.buildings = buildings
                }
            } catch {
                print("Error loading building list: \(error.localizedDescription)")
            }
        } else {
            print("Json file not found")
        }
    }

    var filteredBuildings: [Building] {
        var filteredList: [Building]

        if searchText.isEmpty {
            filteredList = buildings
        } else {
            filteredList = buildings.filter { building in
                building.Name.lowercased().contains(searchText.lowercased())
                    || building.Abbr.lowercased().contains(searchText.lowercased())
            }
        }

        filteredList.sort { $0.Abbr < $1.Abbr }

        return filteredList
    }

    var filteredBuildingsForMap: [Building] {
        var filteredList: [Building] = []

        if !searchDestinationForMap.isEmpty {
            filteredList = buildings.filter { building in
                building.Name.lowercased().contains(searchDestinationForMap.lowercased())
                    || building.Abbr.lowercased().contains(searchDestinationForMap.lowercased())
            }

            filteredList.sort { $0.Abbr < $1.Abbr }
        }
        return filteredList
    }

    // show building annotation on map
    func searchBuilding() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchDestinationForMap
        request.region = locationManager.myRegion
        let results = try? await MKLocalSearch(request: request).start()
        searchResults = results?.mapItems ?? []
    }

    // fetching route
    func fetchRoute() async -> MKRoute {
        let defaultRoute = MKRoute()
        let request = MKDirections.Request()
        request.source = .init(placemark: .init(coordinate: locationManager.myLocation))
        request.destination = searchResults[0]
        print(searchResults[0].placemark)
        request.transportType = .walking

        let result = try? await MKDirections(request: request).calculate()
        return result?.routes.first ?? defaultRoute
    }
}
