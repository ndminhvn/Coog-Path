//
//  BuildingModel.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/21/23.
//

import Foundation
import SwiftData

@Model
class Building: Decodable, Identifiable {
    var id = UUID()
    let Number: String
    let Abbr: String
    let Name: String
    let Photo: String
    let Address: String
    let SampleRoomNumbers: [String]
    var isFavorited: Bool = false
    var courses: [Course]?

    init(id: UUID = UUID(), Number: String, Abbr: String, Name: String, Photo: String, Address: String, SampleRoomNumbers: [String], isFavorited: Bool, courses: [Course]? = nil) {
        self.id = id
        self.Number = Number
        self.Abbr = Abbr
        self.Name = Name
        self.Photo = Photo
        self.Address = Address
        self.SampleRoomNumbers = SampleRoomNumbers
        self.isFavorited = isFavorited
        self.courses = courses
    }

    private enum CodingKeys: String, CodingKey {
        case Number
        case Abbr
        case Name
        case Photo
        case Address
        case SampleRoomNumbers
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        Number = try container.decode(String.self, forKey: .Number)
        Abbr = try container.decode(String.self, forKey: .Abbr)
        Name = try container.decode(String.self, forKey: .Name)
        Photo = try container.decode(String.self, forKey: .Photo)
        Address = try container.decode(String.self, forKey: .Address)
        SampleRoomNumbers = try container.decode([String].self, forKey: .SampleRoomNumbers)
        isFavorited = false
    }
}
