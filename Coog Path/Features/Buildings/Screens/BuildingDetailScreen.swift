//
//  BuildingDetailScreen.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/21/23.
//

import SwiftUI

struct BuildingDetailScreen: View {
    var building: Building
    @EnvironmentObject var buildingVM: BuildingViewModel
    @State private var showHomeScreen = false

    var body: some View {
        VStack(spacing: 2) {
            AsyncImage(url: URL(string: building.Photo)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                    ContentUnavailableView("No Preview Available", systemImage: "eye.slash")
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(height: 200)
                }
            }
            Spacer()
            VStack(alignment: .leading) {
                VStack(alignment: .center) {
                    Text(building.Name)
                        .bold()
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 2)
                    Text(building.Abbr)
                        .fontWeight(.medium)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 2)
                    Text(building.Address)
                }
                VStack(alignment: .leading, spacing: 2) {
                    if building.courses!.count > 0 {
                        Text("Your schedule in this building:")
                            .bold()
                            .font(.headline)
                            .padding(.top, 30)
                        ScrollView {
                            ForEach(building.courses!, id: \.self) { course in
                                HStack {
                                    Label("\(course.name)", systemImage: "book.fill")
                                        .fontWeight(.semibold)
                                    Text("@")
                                    Label("\(course.roomNumber)", systemImage: "studentdesk")
//                                    Spacer()
                                }
                                .padding(.bottom, 3)
                            }
                        }
                        .background(Color.background.opacity(0.3))
                    }
                }
                Spacer()
            }
            .padding(.top, 10)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.white.opacity(0.3))
            Spacer()
            // show on map button
            VStack {
                Button {
                    Task {
                        buildingVM.searchDestinationForMap = building.Name
                        guard !buildingVM.searchDestinationForMap.isEmpty else { return }
                        await buildingVM.searchBuilding()
                        buildingVM.fetchLookAroundPreview()
                        showHomeScreen.toggle()
                    }
                } label: {
                    Text("Show on Map")
                        .font(.title3)
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 45)
                        .padding(.horizontal, 20)
                        .foregroundStyle(.white)
                }
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.main))
                .fullScreenCover(isPresented: $showHomeScreen) {
                    if !buildingVM.searchResults.isEmpty {
                        HomeScreen(searchResults: buildingVM.searchResults[0], showDetails: true)
                    } else {
                        ContentView()
                    }
                }
            }
        }
        .padding()
        .padding(.top, -30)
        .background(Color.background)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    building.isFavorited.toggle()
                }, label: {
                    Image(systemName: building.isFavorited ? "star.fill" : "star")
                        .font(.title3)
                        .foregroundStyle(Color.main.opacity(0.8))
                })
            }
        }
    }
}

#Preview {
    BuildingScreen()
        .modelContainer(for: [Course.self, Building.self])
}
