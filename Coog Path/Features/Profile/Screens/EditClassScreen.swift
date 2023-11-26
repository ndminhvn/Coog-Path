//
//  EditClassScreen.swift
//  Coog Path
//
//  Created by Minh Nguyen on 11/25/23.
//

import SwiftUI

struct EditClassScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State var course: Course

    @State private var timeTo: Date = Date(timeInterval: 5400, since: Date.now)
    @State private var timeFrom: Date = Date.now {
        didSet {
            timeTo = Date(timeInterval: 5400, since: timeFrom)
        }
    }

    let dates = ["Select", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]

    var body: some View {
        NavigationStack {
            Text("Add Class")
                .font(.title)
                .fontWeight(.semibold)
                .padding()
            Spacer()
            Form {
                Section("Course Number") {
                    TextField(text: $course.name) {
                        Text("Enter course number")
                    }
                }
                Section("Room Number") {
                    TextField(text: $course.roomNumber) {
                        Text("Enter room number")
                    }
                }
                Section("Meeting Dates") {
                    Picker("Date 1", selection: $course.date1) {
                        ForEach(dates, id: \.self) { date in
                            Text(date).tag(date)
                        }
                    }
                    Picker("Date 2 (if applicable)", selection: $course.date2) {
                        ForEach(dates, id: \.self) { date in
                            Text(date).tag(date)
                        }
                    }
                    Picker("Date 3 (if applicable)", selection: $course.date3) {
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
                        dismiss()
                    }, label: {
                        Text("Update")
                    })
//                    .disabled(!isFormValid)
                }
            }
        }
    }
}

// #Preview {
//    EditClassScreen()
// }
