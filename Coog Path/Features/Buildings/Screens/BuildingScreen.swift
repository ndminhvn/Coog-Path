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
                            Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                                .font(.title2)
                                .foregroundStyle(Color("MainColor").opacity(0.8))
                        }
                    }
                }
            }
            .navigationTitle("Buildings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                        } label: {
                            Label("All buildings", systemImage: "building")
                        }
                        Button {
                        } label: {
                            Label("Favorited", systemImage: "star")
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
}

#Preview {
    BuildingScreen()
}
