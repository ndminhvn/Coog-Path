//
//  BuildingModel.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/21/23.
//

import Foundation

struct Building: Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case Number
        case Abbr
        case Name
    }
    var id = UUID()
    let Number: String
    let Abbr: String
    let Name: String
}
