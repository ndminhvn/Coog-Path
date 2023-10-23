//
//  EditProfileScreen.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/22/23.
//

import SwiftUI

struct EditProfileScreen: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ProfileViewModel
    @State var newName: String = ""
    
    var displayedName: String {
        return newName.isEmpty ? viewModel.name : newName
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            VStack {
                Image("Profile_photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                Text(displayedName)
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
            }
            Spacer()
            
            VStack {
                Text("Display Name")
                    .bold()
                    .font(.title2)
                TextField(text: $newName) {
                    Text("Enter Name")
                        .font(.title3)
                }
                .padding()
                .multilineTextAlignment(.center)
                .textFieldStyle(.roundedBorder)
            }
            Spacer()
            Spacer()
            
            VStack {
                Button(action: {
                    viewModel.updateName(name: newName)
                    dismiss()
                }) {
                    Text("Update Profile")
                        .font(.title3)
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundStyle(.white)
                        .background(RoundedRectangle(cornerRadius: 16).fill(
                            newName .isEmpty ? .gray.opacity(0.5) : Color("MainColor")))
                }
                .disabled((newName .isEmpty))
                Button(role: .cancel, action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding()
                        .foregroundStyle(Color.accentColor)
                }
            }
        }
        .padding()
    }
}

#Preview {
    EditProfileScreen(viewModel: ProfileViewModel())
}
