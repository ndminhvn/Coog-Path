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
    @State private var isFormUpdated: Bool = false
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
                    .onChange(of: course.name) {
                        isFormUpdated.toggle()
                    }
                }
                Section("Room Number") {
                    TextField(text: $course.roomNumber) {
                        Text("Enter room number")
                    }
                    .onChange(of: course.roomNumber) {
                        isFormUpdated.toggle()
                    }
                }
                Section("Meeting Dates") {
                    Picker("Date 1", selection: $course.date1) {
                        ForEach(dates, id: \.self) { date in
                            Text(date).tag(date)
                        }
                    }
                    .onChange(of: course.date1) {
                        isFormUpdated.toggle()
                    }
                    Picker("Date 2 (if applicable)", selection: $course.date2) {
                        ForEach(dates, id: \.self) { date in
                            Text(date).tag(date as String?)
                        }
                    }
                    .onChange(of: course.date2) {
                        isFormUpdated.toggle()
                    }
                    Picker("Date 3 (if applicable)", selection: $course.date3) {
                        ForEach(dates, id: \.self) { date in
                            Text(date).tag(date as String?)
                        }
                    }
                    .onChange(of: course.date3) {
                        isFormUpdated.toggle()
                    }
                }
                Section("Meeting Time") {
                    DatePicker("From", selection: Binding(
                        get: {
                            // Convert the time string to a Date when getting
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "h:mma"
                            return dateFormatter.date(from: course.timeFrom) ?? Date()
                        },
                        set: {
                            // Convert the Date to a time string when setting
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "h:mma"
                            course.timeFrom = dateFormatter.string(from: $0)
                        }
                    ), displayedComponents: .hourAndMinute)
                        .onChange(of: course.timeFrom) {
                            isFormUpdated.toggle()
                        }
                    DatePicker("To", selection: Binding(
                        get: {
                            // Convert the time string to a Date when getting
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "h:mma"
                            return dateFormatter.date(from: course.timeTo) ?? Date()
                        },
                        set: {
                            // Convert the Date to a time string when setting
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "h:mma"
                            course.timeTo = dateFormatter.string(from: $0)
                        }
                    ), displayedComponents: .hourAndMinute)
                        .onChange(of: course.timeTo) {
                            isFormUpdated.toggle()
                        }
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
                    .disabled(!isFormUpdated)
                }
            }
        }
    }
}

// #Preview {
//    EditClassScreen()
// }
