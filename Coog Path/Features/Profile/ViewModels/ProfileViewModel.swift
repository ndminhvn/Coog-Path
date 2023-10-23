//
//  ProfileViewModel.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/22/23.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var name: String = "Guest User"
    @Published var savedClasses = [Course]()
    
    init() {
        let course = Course(name: "COSC 4355", building: "HBS", room: "315", date: "Thursday", time: "4:00PM - 7:00PM")
        savedClasses.append(course)
    }
    
    func updateName(name: String) {
        self.name = name
    }
}
