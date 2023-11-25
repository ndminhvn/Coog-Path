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

    init(id: UUID = UUID(), name: String, roomNumber: String, building: String? = nil, room: String? = nil, date1: String, date2: String? = nil, date3: String? = nil, timeFrom: String, timeTo: String) {
        self.id = id
        self.name = name
        self.roomNumber = roomNumber
        self.building = building
        self.room = room
        self.date1 = date1
        self.date2 = date2
        self.date3 = date3
        self.timeFrom = timeFrom
        self.timeTo = timeTo
    }
}
