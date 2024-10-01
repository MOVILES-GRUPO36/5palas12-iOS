//
//  RestaurantModel.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 30/09/24.
//

import Foundation

struct Restaurant: Codable, Identifiable {
    var id = UUID()
    var name : String
    var latitude : Double
    var longitude : Double
    var photo : String
    var description : String
    var rating : Float
    var categories : [String]
    
}
