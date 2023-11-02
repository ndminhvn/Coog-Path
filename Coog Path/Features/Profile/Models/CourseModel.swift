//
//  CourseModel.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/22/23.
//

import Foundation
import SwiftData

@Model
class Course: Identifiable {
    var id = UUID()
    var name: String
    var roomNumber: String
    var building: String?
    var room: String?
    var date1: String
    var date2: String?
    var date3: String?
    var timeFrom: String
    var timeTo: String
    
    init(id: UUID = UUID(), name: String, building: String, room: String, date: String, time: String) {
        self.id = id
        self.name = name
        self.building = building
        self.room = room
        self.date = date
        self.time = time
    }
}
