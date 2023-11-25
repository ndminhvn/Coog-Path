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

    init(name: String) {
        self.name = name
    }
}
