//
//  CreditCardView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 29/10/24.
//

import SwiftUI

struct CreditCardView: View {
    var card: CreditCard
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(card.number)
                .font(.headline)
            Text("Expires: \(card.expiryDate)")
                .font(.subheadline)
            Text(card.cardHolder)
                .font(.subheadline)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

#Preview {
    CreditCardView(card : CreditCard.sampleCard)
}
