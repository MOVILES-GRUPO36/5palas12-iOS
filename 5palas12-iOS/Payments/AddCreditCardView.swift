import SwiftUI

struct AddCreditCardView: View {
    @Binding var creditCard: CreditCard
    @EnvironmentObject var creditCardStore: CreditCardStore
    @State private var flip: Bool = false
    @State private var degrees: Double = 0
    @State private var errorMessage: String?
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isCCVFocused: Bool
    
    

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.accentColor)
                        Text("Back")
                            .foregroundColor(.accentColor)
                    }
                }
                Spacer()
            }
            .padding([.top, .leading], 15)
            
            VStack {
                if !flip {
                    CardFrontView(creditCard: creditCard)
                    
                } else {
                    CardBackView(creditCard: creditCard)
                }
            }
            .rotation3DEffect(
                .degrees(degrees),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            .padding(.top, 10)
            
            CheckoutFormView(creditCard: $creditCard, onCCVTapped: {
                withAnimation {
                    degrees += 180
                    flip.toggle()
                }
            })
            
            Button(action: addCreditCard) {
                            Text("Add Card")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.accentColor)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        Spacer()
        }
        .padding(.top, 15)
        .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(errorMessage ?? "An error occurred"), dismissButton: .default(Text("OK")))
                }
        
    }
    
    private func addCreditCard() {
        if isValidCreditCard(creditCard) {
            print("Tarjeta añadida:", creditCard)
            
            creditCardStore.addCreditCard(creditCard)
            
            presentationMode.wrappedValue.dismiss()
        } else {
            showAlert = true
        }
    }
    
    private func isValidCreditCard(_ card: CreditCard) -> Bool {
        guard !card.cardHolder.isEmpty,
              card.number.count == 19,
              card.expiryDate.count == 5,
              (card.cvv.count == 3 || card.cvv.count == 4) else {
            errorMessage = "Please fill in all fields."
            return false
        }

        let components = card.expiryDate.split(separator: "/")
        if components.count == 2,
           let month = Int(components[0]),
           let year = Int(components[1]),
           (1...12).contains(month) {
            return true
        } else {
            errorMessage = "Invalid expiry date. Please use MM/YY format."
            return false
        }
    }
}
