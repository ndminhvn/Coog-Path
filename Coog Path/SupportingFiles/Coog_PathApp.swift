//
//  Coog_PathApp.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/19/23.
//

import SwiftData
import SwiftUI

@main
struct Coog_PathApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Profile.self, Course.self])
    }
}
