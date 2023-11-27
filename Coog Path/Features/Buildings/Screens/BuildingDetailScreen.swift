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
//                VStack(alignment: .leading, spacing: 2) {
//                    Text("Sample room numbers:")
//                        .bold()
//                        .font(.headline)
//                        .padding(.top, 30)
//                    ForEach(building.SampleRoomNumbers, id: \.self) { room in
//                        Label("\(building.Abbr) \(room)", systemImage: "smallcircle.filled.circle")
//                            .padding(.top, 5)
//                    }
//                }
                VStack(alignment: .leading, spacing: 2) {
                    if building.courses!.count > 0 {
                        Text("Your schedule in this building:")
                            .bold()
                            .font(.headline)
                            .padding(.top, 30)
                        ForEach(building.courses!, id: \.self) { course in
                            Label("\(course.name)", systemImage: "smallcircle.filled.circle")
                                .padding(.top, 5)
                        }
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
}
