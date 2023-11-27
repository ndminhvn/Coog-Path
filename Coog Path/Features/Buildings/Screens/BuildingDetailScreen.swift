//
//  BuildingDetailScreen.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/21/23.
//

import SwiftUI

struct BuildingDetailScreen: View {
    var building: Building

    var body: some View {
        VStack(spacing: 2) {
            AsyncImage(url: URL(string: building.Photo)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                    Text("Error image")
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
                                }
                                .padding(.bottom, 3)
                            }
                        }
                        .padding()
                        .background(Color.background.opacity(0.3))
                    }
                }
                Spacer()
            }
            .padding(.top, 10)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.white)
            Spacer()
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
