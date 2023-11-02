//
//  ProfileScreen.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/20/23.
//

import SwiftUI

struct ProfileScreen: View {
    @ObservedObject var viewModel = ProfileViewModel()
    @State private var showingEditProfileSheet = false
    @State private var showingAddClassSheet = false

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
                    EditProfileScreen(viewModel: viewModel)
                }
            }
            VStack(alignment: .center) {
                Image("Profile_photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 70)
                Text(viewModel.name)
                    .font(.title)
                    .fontWeight(.semibold)
            }
            VStack {
                NavigationStack {
                    List {
                        ForEach(viewModel.savedClasses) { course in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(course.name)")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 20))
                                    Text("\(course.roomNumber)")
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("\(course.date1) \(course.date2 ?? "") \(course.date2 ?? "")")
                                        .fontWeight(.medium)
                                    Text("\(course.timeFrom) - \(course.timeTo)")
                                }
                            }
                        }
                        .onMove(perform: { indices, newOffset in
                            viewModel.move(from: indices, to: newOffset)
                        })
                        .onDelete(perform: { indexSet in
                            viewModel.delete(at: indexSet)
                        })
                    }
                    .toolbar {
                        EditButton()
                            .font(.title2)
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .font(.title2)
                                    .foregroundStyle(Color("MainColor"))
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
                        Label {
                            Text("Add class")
                        } icon: {
                            Image(systemName: "plus.circle")
                        }
                        .font(.title2)
                    }
                    .sheet(isPresented: $showingAddClassSheet) {
                        AddClassScreen(viewModel: viewModel)
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ProfileScreen()
}
