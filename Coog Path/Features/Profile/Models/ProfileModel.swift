//
//  ProfileModel.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/22/23.
//

import Foundation
import SwiftData

@Model
class Profile {
    var name: String
    var savedClasses: [Course]

    init(name: String = "Guest User", savedClasses: [Course] = []) {
        self.name = name
        self.savedClasses = savedClasses
    }
}
