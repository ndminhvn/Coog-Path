//
//  CourseModel.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/22/23.
//

import Foundation

struct Course: Identifiable {
    var id = UUID()
    var name: String
    var building: String
    var room: String
    var date: String
    var time: String
}
