//
//  JSONCCFileManager.swift
//  5palas12-iOS
//
//  Created by santiago on 4/11/24.
//

import Foundation

class JSONCCFileManager {
    static let shared = JSONCCFileManager()
    private let fileName = "creditCards.json"
    
    private var fileURL: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(fileName)
    }
    
    func loadCreditCards() -> [CreditCard] {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        print(url)
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([CreditCard].self, from: data)
        } catch {
            print("Error loading credit cards: \(error)")
            return []
        }
    }
    
    func saveCreditCards(_ creditCards: [CreditCard]) {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(creditCards)
            try data.write(to: url)
        } catch {
            print("Error saving credit cards: \(error)")
        }
    }
    
    func saveCreditCard(_ creditCard: CreditCard) {
        var creditCards = loadCreditCards()
        creditCards.append(creditCard)
        saveCreditCards(creditCards)
    }
    
    func deleteCreditCard(at index: Int) {
        var cards = loadCreditCards()
        guard index < cards.count else { return }
        cards.remove(at: index)
        saveCreditCards(cards) 
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
