//
//  BuildingScreen.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/20/23.
//

import SwiftUI

struct BuildingScreen: View {
    @ObservedObject var viewModel = BuildingViewModel()
    @State private var showFilterOptions: Bool = false
    @State private var favoritedStates: [UUID: Bool] = [:]

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
                            Image(systemName: favoritedStates[building.id] ?? false ? "star.fill" : "star")
                                .font(.title3)
                                .foregroundStyle(Color.main.opacity(0.8))
                                .onTapGesture {
                                    print("Add to favorited")
                                    toggleFavorite(for: building)
                                    // Add your favorite logic here
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
                                Label("Favorited", systemImage: "star").tag("Favorited")
                            } label: {
                                Text("Filter")
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title2)
                    }
                }
            }
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onAppear {
                Task {
                    viewModel.loadData()
                }
            }
        }
    }
    private func toggleFavorite(for building: Building) {
        favoritedStates[building.id] = !(favoritedStates[building.id] ?? false)
        print("Building \(building.Name) favorited state: \(favoritedStates[building.id] ?? false)")
        // Add your favorite logic here
    }
}

#Preview {
    BuildingScreen()
}
