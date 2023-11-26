//
//  Coog_PathApp.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/19/23.
//

import SwiftData
import SwiftUI

@main
struct Coog_PathApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Profile.self, Course.self, Building.self])
        .modelContainer(appContainer)
    }
}

// appContainer to pre-load buildings data (first-launch only) from JSON file
@MainActor
let appContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Building.self)

        // Make sure the persistent store is empty. If it's not, return the non-empty container.
        var buildingFetchDescriptor = FetchDescriptor<Building>()
        buildingFetchDescriptor.fetchLimit = 1

        guard try container.mainContext.fetch(buildingFetchDescriptor).count == 0 else { return container }

        // This code will only run if the persistent store is empty.
        var buildings = [Building]()
        if let url = Bundle.main.url(forResource: "building_list", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let buildingList = try JSONDecoder().decode([Building].self, from: data)
                buildings = buildingList
            } catch {
                print("Error loading building list: \(error.localizedDescription)")
            }
        } else {
            print("Json file not found")
        }

        for building in buildings {
            container.mainContext.insert(building)
        }

        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
