//
//  BuildingScreen.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/20/23.
//

import SwiftData
import SwiftUI

struct BuildingScreen: View {
    @Environment(\.modelContext) private var modelContext
    // all buildings
    @Query var buildings: [Building]
    // favorited buildings only
    @Query(filter: #Predicate<Building> { $0.isFavorited }) var favoritedBuildings: [Building]
    @EnvironmentObject var viewModel: BuildingViewModel
    @State private var showFilterOptions: Bool = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.filteredBuildings) { building in
                    NavigationLink(destination: BuildingDetailScreen(building: building)) {
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
                        .overlay(alignment: .trailing) {
                            // Add to favorited
                            Image(systemName: building.isFavorited ? "star.fill" : "star")
                                .font(.title3)
                                .foregroundStyle(Color.main.opacity(0.8))
                                .onTapGesture {
                                    building.isFavorited.toggle()
                                }
                        }
                    }
                }
            }
            .navigationTitle("Buildings")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Section(header: Text("Filter")) {
                            Picker(selection: $viewModel.filterOption) {
                                Label("All buildings", systemImage: "building").tag("All buildings")
                                Label("Favorites", systemImage: "star").tag("Favorites")
                            } label: {
                                Text("Filter")
                            }
                        }
                    } label: {
                        Image(systemName: viewModel.filterOption == "All buildings" ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onAppear {
                // assign viewModel buildings array = query result
                viewModel.buildings = buildings
                viewModel.favoritedBuilding = favoritedBuildings
            }
            .onChange(of: buildings) {
                viewModel.buildings = buildings
            }
            .onChange(of: favoritedBuildings) {
                viewModel.favoritedBuilding = favoritedBuildings
            }
        }
    }
}

#Preview {
    BuildingScreen()
        .modelContainer(for: [Building.self])
}
