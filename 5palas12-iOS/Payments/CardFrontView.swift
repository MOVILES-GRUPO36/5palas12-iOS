//
//  CardFrontView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 29/10/24.
//

import SwiftUI

struct CardFrontView: View {
    
    let creditCard: CreditCard
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .padding()
                Spacer()
                Text("VISA")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .italic()
                    .padding()
            }
            
            Text(creditCard.number.isEmpty ? " ": creditCard.number)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .padding()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("CARD HOLDER")
                        .opacity(0.5)
                    .font(.system(size: 14))
                    Text(creditCard.cardHolder.isEmpty ? " ": creditCard.cardHolder)
                }
               
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("EXPIRES")
                        .opacity(0.5)
                    .font(.system(size: 14))
                    Text(creditCard.expiryDate.isEmpty ? " ": creditCard.expiryDate)
                }
                
            }.padding()
               
            Spacer()
        }
        .foregroundStyle(.white)
        .frame(width: 350, height: 250)
        .background {
            LinearGradient(colors: [.walnutBrown, .fernGreen], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
    }
}
