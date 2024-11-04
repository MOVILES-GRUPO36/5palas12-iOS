//
//  CheckoutFormView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 29/10/24.
//

import SwiftUI

struct CheckoutFormView: View {
    
    @Binding var creditCard: CreditCard
    let onCCVTapped: () -> Void
    @FocusState private var isCCVFocused: Bool
    
    var body: some View {
        Form {
            TextField("Cardholder's Name", text: $creditCard.cardHolder)
                .textContentType(.name)
                .onChange(of: creditCard.cardHolder) { newValue in
                    // Limitar a solo letras y un máximo de 26 caracteres
                    creditCard.cardHolder = newValue.filter { $0.isLetter || $0.isWhitespace }
                        .prefix(26).description
                }
            
            TextField("Card Number", text: $creditCard.number)
                .keyboardType(.numberPad)
                .onChange(of: creditCard.number) { newValue in
                    // Formatear el número de tarjeta en bloques de 4
                    creditCard.number = formatCardNumber(newValue)
                }
            
            TextField("Expiry Date (MM/YY)", text: $creditCard.expiryDate)
                .keyboardType(.numberPad)
                .onChange(of: creditCard.expiryDate) { newValue in
                    // Formato de "MM/YY"
                    creditCard.expiryDate = formatExpiryDate(newValue)
                }
            
            TextField("CCV", text: $creditCard.cvv)
                .keyboardType(.numberPad)
                .focused($isCCVFocused)
                .onChange(of: creditCard.cvv) { newValue in
                    // Limitar a solo dígitos y un máximo de 4 caracteres
                    creditCard.cvv = newValue.filter { $0.isNumber }
                        .prefix(3).description
                }
        }
        .onChange(of: isCCVFocused) { isFocused in
            if isFocused {
                onCCVTapped()
            }
        }
    }
    
    // Función para formatear el número de tarjeta en bloques de 4
    private func formatCardNumber(_ input: String) -> String {
        let cleanedInput = input.filter { $0.isNumber }.prefix(16)
        let grouped = stride(from: 0, to: cleanedInput.count, by: 4).map {
            let start = cleanedInput.index(cleanedInput.startIndex, offsetBy: $0)
            let end = cleanedInput.index(start, offsetBy: 4, limitedBy: cleanedInput.endIndex) ?? cleanedInput.endIndex
            return String(cleanedInput[start..<end])
        }
        return grouped.joined(separator: " ")
    }
    
    // Función para formatear la fecha de expiración en "MM/YY"
    private func formatExpiryDate(_ input: String) -> String {
        let cleanedInput = input.filter { $0.isNumber }
        if cleanedInput.count <= 2 {
            return cleanedInput // Solo "MM"
        } else {
            let month = cleanedInput.prefix(2)
            let year = cleanedInput.suffix(from: cleanedInput.index(cleanedInput.startIndex, offsetBy: 2))
                .prefix(2)
            return "\(month)/\(year)" // "MM/YY"
        }
    }
}
