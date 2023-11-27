//
//  AddClassScreen.swift
//  Coog Path
//
//  Created by Minh Nguyen on 11/2/23.
//

import SwiftData
import SwiftUI

struct AddClassScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Query var buildings: [Building]

    @State private var name: String = ""
    @State private var roomNumber: String = ""
    @State private var date1: String = ""
    @State private var date2: String = ""
    @State private var date3: String = ""
    @State private var timeTo: Date = Date(timeInterval: 5400, since: Date.now)
    @State private var timeFrom: Date = Date.now {
        didSet {
            timeTo = Date(timeInterval: 5400, since: timeFrom)
        }
    }

    @State private var isValidRoom: Bool = false
    @State private var foundBuildingAbbr: String = ""
    @State private var foundRoom: String = ""

    let dates = ["Select", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]

    // check if all required fields got values
    private var isFormValid: Bool {
        !name.isEmpty && isValidRoom && !date1.isEmpty
            && !timeFrom.description.isEmpty && !timeTo.description.isEmpty
    }

    // validate the entered roomNumber, to add corresponding building to favorites
    func validateRoomNumber(_ roomNumber: String) {
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

    var body: some View {
        NavigationStack {
            Text("Add Class")
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
                            Text(date).tag(date)
                        }
                    }
                    .onChange(of: date2) {
                        date2 = (date2 == "Select") ? "" : date2
                    }
                    Picker("Date 3 (if applicable)", selection: $date3) {
                        ForEach(dates, id: \.self) { date in
                            Text(date).tag(date)
                        }
                    }
                    .onChange(of: date3) {
                        date3 = (date3 == "Select") ? "" : date3
                    }
                }
                Section("Meeting Time") {
                    DatePicker("From", selection: $timeFrom, displayedComponents: .hourAndMinute)
                    DatePicker("To", selection: $timeTo, displayedComponents: .hourAndMinute)
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
                        if isValidRoom {
                            roomNumber = "\(foundBuildingAbbr) \(foundRoom)"
                        }
                        modelContext.insert(Course(name: name, roomNumber: roomNumber, building: foundBuildingAbbr, room: foundRoom, date1: date1, date2: date2, date3: date3, timeFrom: timeFrom.formatted(date: .omitted, time: .shortened), timeTo: timeTo.formatted(date: .omitted, time: .shortened)))
                        dismiss()
                    }, label: {
                        Text("Done")
                    })
                    .disabled(!isFormValid)
                }
            }
        }
    }
}

#Preview {
    AddClassScreen()
}
