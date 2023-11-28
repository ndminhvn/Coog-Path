//
//  EditClassScreen.swift
//  Coog Path
//
//  Created by Minh Nguyen on 11/25/23.
//

import SwiftData
import SwiftUI

struct EditClassScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Query var buildings: [Building]
    var course: Course

    let dates = ["Select", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]

    @State private var name: String = ""
    @State private var roomNumber: String = ""
    @State private var date1: String = ""
    @State private var date2: String = ""
    @State private var date3: String = ""
    @State private var timeTo: String = ""
    @State private var timeFrom: String = ""

    @State private var isValidRoom: Bool = false
    @State private var foundBuildingAbbr: String = ""
    @State private var foundRoom: String = ""

    // check if any data changed and valid
    private var isFormValid: Bool {
        (!name.isEmpty && name != course.name)
            || (roomNumber != course.roomNumber && isValidRoom)
            || date1 != course.date1
            || date2 != course.date2
            || date3 != course.date3
            || timeFrom != course.timeFrom
            || timeTo != course.timeTo
    }

    private func updateStateFromCourse() {
        name = course.name
        roomNumber = course.roomNumber
        foundBuildingAbbr = course.building
        foundRoom = course.room
        date1 = course.date1
        date2 = course.date2 ?? ""
        date3 = course.date3 ?? ""
        timeFrom = course.timeFrom
        timeTo = course.timeTo
    }

    // validate the entered roomNumber, to add corresponding building to favorites
    private func validateRoomNumber(_ roomNumber: String) {
        let components = roomNumber.components(separatedBy: " ")

        if components.count >= 2 {
            // If the roomNumber contains a space, validate based on the first component
            let buildingAbbreviation = components[0]
            isValidRoom = buildings.contains { building in
                buildingAbbreviation == building.Abbr
            }
            if isValidRoom == true {
                foundBuildingAbbr = buildingAbbreviation
                foundRoom = components[1]
            }

        } else {
            // If there is no space, attempt to separate the string by numbers
            // For ex: PGH232 will be separated to PGH and 232
            if let range = roomNumber.rangeOfCharacter(from: .decimalDigits) {
                let index = range.lowerBound
                let buildingAbbreviation = String(roomNumber[..<index])
                isValidRoom = buildings.contains { building in
                    buildingAbbreviation == building.Abbr
                }
                if isValidRoom == true {
                    foundBuildingAbbr = buildingAbbreviation
                    foundRoom = String(roomNumber[index...])
                }
            } else {
                // No numbers found, consider it invalid
                isValidRoom = false
            }
        }
    }

    private func updateClass() {
        // update course with field data
        if isValidRoom {
            roomNumber = "\(foundBuildingAbbr) \(foundRoom)"
        }

        // remove course from building's courses list if building change
        if foundBuildingAbbr != course.building {
            if let oldBuilding = buildings.first(where: { $0.Abbr == course.building }) {
                oldBuilding.courses?.removeAll { $0.id == course.id }
            }
        }

        // update course details
        course.name = name
        course.roomNumber = roomNumber
        course.building = foundBuildingAbbr
        course.room = foundRoom
        course.date1 = date1
        course.date2 = date2
        course.date3 = date3
        course.timeFrom = timeFrom
        course.timeTo = timeTo

        // add the selected building to favorites, also add the course to building's courses list
        if let building: Building = {
            return buildings.first { $0.Abbr == foundBuildingAbbr }
        }() {
            building.isFavorited = isValidRoom
            building.courses?.append(course)
        }
    }

    var body: some View {
        NavigationStack {
            Text("Edit Class")
                .font(.title)
                .fontWeight(.semibold)
                .padding()
            Spacer()
            Form {
                Section("Course Number") {
                    TextField(text: $name) {
                        Text("Ex: COSC 4355")
                    }
                    .onChange(of: name) {
                        name = name.uppercased()
                    }
                }
                Section {
                    TextField(text: $roomNumber) {
                        Text("Ex: PGH 232")
                    }
                    .onAppear(perform: {
                        validateRoomNumber(roomNumber)
                    })
                    .onChange(of: roomNumber) {
                        roomNumber = roomNumber.uppercased()
                        validateRoomNumber(roomNumber)
                    }
                } header: {
                    Text("Room Number")
                } footer: {
                    // if roomNumber is not empty, show invalid/valid
                    if roomNumber.isEmpty {
                        Text("")
                    } else {
                        if !isValidRoom {
                            Text("Invalid room number. Please try again!")
                        } else {
                            Text("Valid building: \(foundBuildingAbbr), room \(foundRoom)")
                        }
                    }
                }
                .onChange(of: roomNumber) {
                    roomNumber = roomNumber.uppercased()
                    validateRoomNumber(roomNumber)
                }
                Section("Meeting Dates") {
                    Picker("Date 1", selection: $date1) {
                        ForEach(dates, id: \.self) { date in
                            Text(date).tag(date)
                        }
                    }
                    .onChange(of: date1) {
                        date1 = (date1 == "Select") ? "" : date1
                    }
                    Picker("Date 2 (if applicable)", selection: $date2) {
                        ForEach(dates, id: \.self) { date in
                            Text(date).tag(date as String?)
                        }
                    }
                    .onChange(of: date2) {
                        date2 = (date2 == "Select") ? "" : date2
                    }
                    Picker("Date 3 (if applicable)", selection: $date3) {
                        ForEach(dates, id: \.self) { date in
                            Text(date).tag(date as String?)
                        }
                    }
                    .onChange(of: date3) {
                        date3 = (date3 == "Select") ? "" : date3
                    }
                }
                Section("Meeting Time") {
                    DatePicker("From", selection: Binding(
                        get: {
                            // Convert the time string to a Date when getting
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "h:mma"
                            return dateFormatter.date(from: timeFrom) ?? Date()
                        },
                        set: {
                            // Convert the Date to a time string when setting
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "h:mma"
                            timeFrom = dateFormatter.string(from: $0)
                        }
                    ), displayedComponents: .hourAndMinute)
                    DatePicker("To", selection: Binding(
                        get: {
                            // Convert the time string to a Date when getting
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "h:mma"
                            return dateFormatter.date(from: timeTo) ?? Date()
                        },
                        set: {
                            // Convert the Date to a time string when setting
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "h:mma"
                            timeTo = dateFormatter.string(from: $0)
                        }
                    ), displayedComponents: .hourAndMinute)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .cancel, action: {
                        dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        updateClass()
                        dismiss()
                    }, label: {
                        Text("Update")
                    })
                    .disabled(!isFormValid)
                }
            }
        }
        .onAppear {
            updateStateFromCourse()
        }
    }
}

// #Preview {
//    EditClassScreen()
// }
