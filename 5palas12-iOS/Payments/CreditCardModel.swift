//
//  CreditCardModel.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 29/10/24.
//

import Foundation

struct CreditCard: Identifiable, Codable {
    let id = UUID()
    var number: String
    var expiryDate: String
    var cardHolder: String
    var cvv: String

    init() {
        self.number = ""
        self.expiryDate = ""
        self.cardHolder = ""
        self.cvv = ""
    }

    init(number: String, expiryDate: String, cardHolder: String, cvv: String) {
        self.number = number
        self.expiryDate = expiryDate
        self.cardHolder = cardHolder
        self.cvv = cvv
    }

//    init(id: Int64, number: String, expiryDate: String, cardHolder: String, cvv: String) {
//        self.id = id // Properly assign the id
//        self.number = number
//        self.expiryDate = expiryDate
//        self.cardHolder = cardHolder
//        self.cvv = cvv
//    }
}

extension CreditCard {
    public static var sampleCard = CreditCard(number: "1234 5678 9012 3456", expiryDate: "12/24", cardHolder: "John Doe", cvv: "123")
}
