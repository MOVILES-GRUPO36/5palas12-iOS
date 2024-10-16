//
//  RestaurantModel.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 30/09/24.
//

import Foundation

struct RestaurantModel: Decodable, Identifiable {
    var id = UUID()
    var name : String
    var latitude : Double
    var longitude : Double
    var photo : String
    var categories : [String]
    var description : String
    var rating : Double
    var address : String
    var distance : Double?
    enum CodingKeys : String, CodingKey{
        case name
        case latitude
        case longitude
        case photo
        case categories
        case description
        case rating
        case address
    }
}
