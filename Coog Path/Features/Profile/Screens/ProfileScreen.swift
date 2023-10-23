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
                                    Text(course.name)
                                        .fontWeight(.semibold)
                                        .font(.system(size: 20))
                                    Text("\(course.building) \(course.room)")
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(course.date)
                                        .fontWeight(.medium)
                                    Text(course.time)
                                }
                            }
                        }
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
