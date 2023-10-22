//
//  BuildingScreen.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/20/23.
//

import SwiftUI

struct BuildingScreen: View {
    @ObservedObject var viewModel = BuildingViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.filteredBuildings) { building in
                    NavigationLink(destination: BuildingDetailScreen()) {
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
                                .resizable()
                                .scaledToFit()
                                .frame(height: 25)
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Buildings")
            .searchable(text: $viewModel.searchText)
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
