//
//  ProductModel.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 20/10/24.
//

import Foundation

struct ProductModel : Codable, Identifiable, Hashable{
    var id = UUID()
    var name: String
    var price: Double
    var category : String
    var photo : String
    var co2Emissions: Double
    var weight: Double
    var restaurant: String
    enum CodingKeys: String, CodingKey {
        case name
        case price
        case category
        case photo
        case co2Emissions
        case weight
        case restaurant
    }
}
