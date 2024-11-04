//
//  PaymentMethodsView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 29/10/24.
//

import SwiftUI

struct PaymentMethodsView: View {
    @State private var creditCards: [CreditCard] = [
        CreditCard.sampleCard
    ]
    @Environment(\.presentationMode) var presentationMode
    @State private var newCreditCard: CreditCard = CreditCard()
    @State private var addCreditCard: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0){
                LogoView()
                    .padding(.all, 0)
                Spacer()
                ScrollView {
                    ForEach(creditCards) { card in
                        CardFrontView(creditCard: card)
                    }
                }
                Button{
                    addCreditCard.toggle()
                } label: {
                    Text("Add Credit Card")
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
            }
        }.navigationBarBackButtonHidden(true)
            .overlay(alignment: .topLeading){
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("Timberwolf"))
                        Text("Back")
                            .foregroundColor(Color("Timberwolf"))
                    }
                }.offset(x: 10,y: 18)
                
            }
            .sheet(isPresented: $addCreditCard){
                AddCreditCardView(creditCard: $newCreditCard) }
        
    }
}

