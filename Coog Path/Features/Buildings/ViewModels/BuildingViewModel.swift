//
//  BuildingViewModel.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/21/23.
//

import Foundation

class BuildingViewModel: ObservableObject {
    @Published var buildings = [Building]()
    @Published var searchText: String = ""
    @Published var searchDestinationForMap: String = ""

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
        var filteredList : [Building] = []

        if !searchDestinationForMap.isEmpty {
            filteredList = buildings.filter { building in
                building.Name.lowercased().contains(searchDestinationForMap.lowercased())
                    || building.Abbr.lowercased().contains(searchDestinationForMap.lowercased())
            }

            filteredList.sort { $0.Abbr < $1.Abbr }
        }
        return filteredList
    }
}
