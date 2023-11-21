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
    
    init(id: UUID = UUID(), name: String, roomNumber: String, date1: String, date2: String?, timeFrom: String, timeTo: String) {
        self.id = id
        self.name = name
        self.roomNumber = roomNumber
        self.date1 = date1
        self.date2 = date2
        self.timeFrom = timeFrom
        self.timeTo = timeTo
    }
}
