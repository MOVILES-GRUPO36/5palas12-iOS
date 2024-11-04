//
//  CardBackView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 29/10/24.
//

import SwiftUI

struct CardBackView: View {
    
    let creditCard: CreditCard
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(.black)
                .frame(maxWidth: .infinity, maxHeight: 22)
                .padding([.top], 20)
            
            Spacer()
            
            HStack {
                
                Text(" \(creditCard.cvv)")
                    .frame(width: 100, height: 33, alignment: .leading)
                    .background(.white)
                    .foregroundStyle(.black)
                    .rotation3DEffect(
                        .degrees(180),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    ).padding([.leading, .trailing, .bottom], 20)
                
               
                Spacer()
            }
                
                
        }
        .foregroundStyle(.white)
        .frame(width: 350, height: 250)
        .background {
            LinearGradient(colors: [.walnutBrown, .fernGreen], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
    }
}
