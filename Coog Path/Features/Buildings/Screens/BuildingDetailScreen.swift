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
        VStack {
            VStack {
                Rectangle()
                    .foregroundStyle(.brown)
                    .frame(maxHeight: 200)
            }
            Spacer()
            VStack (alignment: .leading) {
                VStack(alignment: .center) {
                    Text(building.Name)
                        .bold()
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    Text("Address")
                }
                Spacer()
                Section {
                    Text("Sample room numbers:")
                        .bold()
                        .font(.headline)
                }
                Spacer()
                Section {
                    Text("Your classes in this building:")
                        .bold()
                        .font(.headline)
                }
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.blue.opacity(0.75))
            Spacer()
        }
        .padding()
        .padding(.top, -30)
    }
}

#Preview {
    BuildingDetailScreen(building: Building(Number: "0001", Abbr: "PGH", Name: "Philip"))
}
