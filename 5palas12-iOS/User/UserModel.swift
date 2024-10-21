//
//  UserModel.swift
//  5palas12-iOS
//
//  Created by santiago on 19/10/2024.
//

import Foundation

class UserModel: Decodable, Identifiable, ObservableObject{
    @Published var id = UUID().uuidString
    @Published var name : String
    @Published var surname : String
    @Published var email : String
    @Published var birthday : Date
    @Published var createdAt : Date
    
    init (id: String, name: String, surname: String, email: String, birthday: Date, createdAt: Date){
        self.id = id
        self.name = name
        self.surname = surname
        self.email = email
        self.birthday = birthday
        self.createdAt = createdAt
    }
    
    enum CodingKeys : String, CodingKey{
        case name
        case surname
        case email
        case birthday
        case createdAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID().uuidString
        self.name = try container.decode(String.self, forKey: .name)
        self.surname = try container.decode(String.self, forKey: .surname)
        self.email = try container.decode(String.self, forKey: .email)
        self.birthday = try container.decode(Date.self, forKey: .birthday)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
    }
}
