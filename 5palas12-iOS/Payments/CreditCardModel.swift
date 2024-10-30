//
//  CreditCardModel.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 29/10/24.
//

import Foundation

struct CreditCard: Identifiable {
    let id = UUID()
    var number: String
    var expiryDate: String
    var cardHolder: String
    var ccv: String
    
    init() {
        self.number = ""
        self.expiryDate = ""
        self.cardHolder = ""
        self.ccv = ""
    }
    
    init (number: String, expiryDate: String, cardHolder: String, ccv: String) {
        self.number = number
        self.expiryDate = expiryDate
        self.cardHolder = cardHolder
        self.ccv = ccv
    }
}

extension CreditCard {
    public static var sampleCard = CreditCard(number: "1234 5678 9012 3456", expiryDate: "12/24", cardHolder: "John Doe", ccv: "123")
}
