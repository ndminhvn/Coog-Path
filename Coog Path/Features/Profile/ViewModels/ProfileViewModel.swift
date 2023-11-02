//
//  ProfileViewModel.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/22/23.
//

import Foundation
import SwiftData

class ProfileViewModel: ObservableObject {
    @Published var name: String = "Guest User"
    @Published var savedClasses = [Course]()

    func updateName(name: String) {
        self.name = name
    }

    func move(from source: IndexSet, to destination: Int) {
        savedClasses.move(fromOffsets: source, toOffset: destination)
    }

    func delete(at offsets: IndexSet) {
        savedClasses.remove(atOffsets: offsets)
    }
    
    func addCourse(course: Course) {
        savedClasses.append(course)
    }
}
