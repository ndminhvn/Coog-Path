//
//  ContentView.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/19/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeScreen()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            BuildingScreen()
                .tabItem {
                    Label("Buildings", systemImage: "building")
                }
            ProfileScreen()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .tint(Color.main)
    }
}

#Preview {
    ContentView()
}
