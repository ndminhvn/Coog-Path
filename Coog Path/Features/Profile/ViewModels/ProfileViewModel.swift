//
//  ProfileViewModel.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/22/23.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var name: String = "Guest User"
    @Published var savedClasses = [Course]()
}
