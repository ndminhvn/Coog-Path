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
                    Text(building.Address)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Sample room numbers:")
                        .bold()
                        .font(.headline)
                        .padding(.top, 30)
                    ForEach(building.SampleRoomNumbers, id: \.self) { room in
                        Label("\(building.Abbr) \(room)", systemImage: "smallcircle.filled.circle")
                            .padding(.top, 5)
                    }
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Your classes in this building:")
                        .bold()
                        .font(.headline)
                        .padding(.top, 30)
                }
                Spacer()
            }
            .padding(.top, 10)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.white)
            Spacer()
            // Future: may add this feature
//            Button {
//                // add to favorites
//                print("Clicked add to favorite")
//            } label: {
//                Text("Add to favorites")
//            }
        }
        .padding()
        .padding(.top, -30)
        .background(Color.background)
    }
}

#Preview {
    BuildingScreen()
}
