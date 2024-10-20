//
//  UserModel.swift
//  5palas12-iOS
//
//  Created by santiago on 19/10/2024.
//

import Foundation

struct UserModel: Decodable, Identifiable {
    var id = UUID()
    var name : String
    var surname : String
    var email : String
    var birthday : Date
    var createdAt : Date
    enum CodingKeys : String, CodingKey{
        case name
        case surname
        case email
        case birthday
        case createdAt
    }
}
