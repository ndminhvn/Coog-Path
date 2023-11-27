//
//  AddClassScreen.swift
//  Coog Path
//
//  Created by Minh Nguyen on 11/2/23.
//

import SwiftUI

struct AddClassScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
//    @ObservedObject var viewModel: ProfileViewModel
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

    let dates = ["Select", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]

    private var isFormValid: Bool {
        !name.isEmpty && !roomNumber.isEmpty && !date1.isEmpty
            && !timeFrom.description.isEmpty && !timeTo.description.isEmpty
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
                        Text("For ex: COSC 4355")
                    }
                }
                Section("Room Number") {
                    TextField(text: $roomNumber) {
                        Text("For ex: PGH 232")
                    }
                }
                Section("Meeting Dates") {
                    Picker("Date 1", selection: $date1) {
                        ForEach(dates, id: \.self) { date in
                            Text(date).tag(date)
                        }
                    }
                    Picker("Date 2 (if applicable)", selection: $date2) {
                        ForEach(dates, id: \.self) { date in
                            Text(date).tag(date)
                        }
                    }
                    Picker("Date 3 (if applicable)", selection: $date3) {
                        ForEach(dates, id: \.self) { date in
                            Text(date).tag(date)
                        }
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
                        modelContext.insert(Course(name: name, roomNumber: roomNumber, date1: date1, date2: date2, date3: date3, timeFrom: timeFrom.formatted(date: .omitted, time: .shortened), timeTo: timeTo.formatted(date: .omitted, time: .shortened)))
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
