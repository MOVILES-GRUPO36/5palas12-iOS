//
//  PaymentMethodsView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 29/10/24.
//

import SwiftUI

struct PaymentMethodsView: View {
    @State private var newCreditCard: CreditCard = CreditCard(number: "", expiryDate: "", cardHolder: "", cvv: "")
    @State private var addCreditCard: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var creditCardStore = CreditCardStore() 
    @State private var showDeleteAlert: Bool = false
    @State private var cardIndexToDelete: Int?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                LogoView()
                    .padding(.all, 0)
                Spacer()
                ScrollView {
                    ForEach(creditCardStore.creditCards.indices, id: \.self) { index in
                        ZStack {
                            CardFrontView(creditCard: creditCardStore.creditCards[index])
                                .padding(.bottom, 40)
                            
                            Button(action: {
                                cardIndexToDelete = index
                                showDeleteAlert = true
                            }) {
                                Text("Delete")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.red)
                                    .cornerRadius(5)
                            }
                            .padding(.bottom, 10)
                            .offset(y: 80)
                        }
                    }
                }
                Button {
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
            .navigationBarBackButtonHidden(true)
            .onAppear {
                creditCardStore.creditCards = JSONCCFileManager.shared.loadCreditCards()
            }
            .overlay(alignment: .topLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("Timberwolf"))
                        Text("Back")
                            .foregroundColor(Color("Timberwolf"))
                    }
                }.offset(x: 10, y: 18)
            }
            .sheet(isPresented: $addCreditCard) {
                AddCreditCardView(creditCard: $newCreditCard)
                    .environmentObject(creditCardStore)
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Card"),
                    message: Text("Are you sure you want to delete this card?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let index = cardIndexToDelete {
                            deleteCreditCard(at: index)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    private func deleteCreditCard(at index: Int) {
        creditCardStore.deleteCreditCard(at: index)
    }
}
