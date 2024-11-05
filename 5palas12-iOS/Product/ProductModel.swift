//
//  ProductModel.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 20/10/24.
//

import Foundation

struct ProductModel : Decodable, Identifiable, Hashable{
    var id = UUID()
    var name: String
    var price: Double
    var categories : [String]
    var photo : String
    enum CodingKeys: String, CodingKey {
        case name
        case price
        case categories
        case photo
    }
}
