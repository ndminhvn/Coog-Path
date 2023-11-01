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
        case Photo
        case Address
        case SampleRoomNumbers
    }
    var id = UUID()
    let Number: String
    let Abbr: String
    let Name: String
    let Photo: String
    let Address: String
    let SampleRoomNumbers: [String]
}
