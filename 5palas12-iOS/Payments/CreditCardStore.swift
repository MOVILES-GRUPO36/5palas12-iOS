//
//  CreditCardStore.swift
//  5palas12-iOS
//
//  Created by santiago on 4/11/24.
//

import Foundation
import Combine

class CreditCardStore: ObservableObject {
    @Published var creditCards: [CreditCard] = []

    init() {
        loadCreditCards()
    }
    
    func loadCreditCards() {
        creditCards = JSONCCFileManager.shared.loadCreditCards()
    }

    func addCreditCard(_ card: CreditCard) {
        creditCards.append(card)
        saveCreditCards(creditCards)
    }
    
    func deleteCreditCard(at index: Int) {
        JSONCCFileManager.shared.deleteCreditCard(at: index)
        loadCreditCards()
    }

    func saveCreditCards(_ cards: [CreditCard]) {
        JSONCCFileManager.shared.saveCreditCards(cards) 
    }
}
