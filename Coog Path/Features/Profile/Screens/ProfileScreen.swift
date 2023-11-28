//
//  ProfileScreen.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/20/23.
//

import SwiftData
import SwiftUI

struct ProfileScreen: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel = ProfileViewModel()
    @State private var showingEditProfileSheet = false
    @State private var showingAddClassSheet = false
    @Query var profiles: [Profile]
    @Query var courses: [Course]
    @Query var buildings: [Building]
    @State private var savedClasses: [Course] = []
    @State private var selectedClassToEdit: Course? = nil

    var body: some View {
        VStack {
            HStack {
                Text("Profile")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Button(action: {
                    showingEditProfileSheet.toggle()
                }, label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title)
                })
                .sheet(isPresented: $showingEditProfileSheet) {
                    EditProfileScreen()
                }
            }
            VStack(alignment: .center) {
                Image("Profile_photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 70)
                if !profiles.isEmpty {
                    Text(profiles[0].name)
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }
            VStack {
                NavigationStack {
                    List {
                        ForEach(savedClasses) { course in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(course.name)")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 20))
                                    Text("\(course.roomNumber)")
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("\(course.date1) \(course.date2 ?? "") \(course.date3 ?? "")")
                                        .fontWeight(.medium)
                                    Text("\(course.timeFrom) - \(course.timeTo)")
                                }
                            }
                            .onTapGesture(perform: {
                                selectedClassToEdit = course
                            })
                        }
                        .onMove(perform: { indices, newOffset in
                            savedClasses.move(fromOffsets: indices, toOffset: newOffset)
                        })
                        .onConfirmedDelete(
                            title: { indexSet in
                                "Delete course “\(savedClasses[indexSet.first!].name)”?"
                            },
                            message: "This cannot be undone.",
                            action: { indexSet in
                                // delete course from storage
                                let courseToDelete = savedClasses[indexSet.first!]
                                modelContext.delete(courseToDelete)

                                // delete course from building's courses list
                                if let building = buildings.first(where: { $0.Abbr == courseToDelete.building }) {
                                    building.courses?.removeAll { $0.id == courseToDelete.id }
                                }
                            }
                        )
                        .sheet(item: $selectedClassToEdit) { course in
                            EditClassScreen(course: course)
                        }
                    }
                    .toolbar {
                        EditButton()
                            .font(.title2)
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .font(.title2)
                                    .foregroundStyle(Color.main)
                                Text("Saved Classes")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                    Button {
                        showingAddClassSheet.toggle()
                    } label: {
                        Label("Add class", systemImage: "plus.circle")
                            .font(.title2)
                    }
                    .sheet(isPresented: $showingAddClassSheet) {
                        AddClassScreen()
                    }
                }
            }
            Spacer()
        }
        .padding()
        .onAppear(perform: {
            if profiles.isEmpty {
                modelContext.insert(Profile(name: "Guest User"))
            }
            savedClasses = courses
        })
        .onChange(of: courses) {
            savedClasses = courses
        }
    }
}

extension DynamicViewContent {
    func onConfirmedDelete(title: @escaping (IndexSet) -> String, message: String? = nil, action: @escaping (IndexSet) -> Void) -> some View {
        DeleteConfirmation(source: self, title: title, message: message, action: action)
    }
}

struct DeleteConfirmation<Source>: View where Source: DynamicViewContent {
    let source: Source
    let title: (IndexSet) -> String
    let message: String?
    let action: (IndexSet) -> Void
    @State var indexSet: IndexSet = []
    @State var isPresented: Bool = false

    var body: some View {
        source
            .onDelete { indexSet in
                self.indexSet = indexSet
                isPresented = true
            }
            .alert(isPresented: $isPresented) {
                Alert(
                    title: Text(title(indexSet)),
                    message: message == nil ? nil : Text(message!),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(
                        Text("Delete"),
                        action: {
                            withAnimation {
                                action(indexSet)
                            }
                        }
                    )
                )
            }
    }
}

#Preview {
    ProfileScreen()
        .modelContainer(for: [Profile.self, Course.self, Building.self])
}
