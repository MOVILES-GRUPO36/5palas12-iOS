import SwiftUI

struct AddCreditCardView: View {
    @Binding var creditCard: CreditCard
    @EnvironmentObject var creditCardStore: CreditCardStore
    @State private var flip: Bool = false
    @State private var degrees: Double = 0
    @State private var errorMessage: String? // Variable para el mensaje de error
    @State private var showAlert = false // Estado para controlar la presentación del alert
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isCCVFocused: Bool
    
    

    var body: some View {
        VStack {
            // Botón de retroceso en la parte superior izquierda
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
            
            // Botón para agregar tarjeta
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
        // Presenta el alert cuando showAlert es verdadero
        .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(errorMessage ?? "An error occurred"), dismissButton: .default(Text("OK")))
                }
        
    }
    
    private func addCreditCard() {
        // Validar los datos de la tarjeta
        if isValidCreditCard(creditCard) {
            // If the card is valid, append it to the list
            // and save it to the JSON file
            print("Tarjeta añadida:", creditCard)
            
            // Save the new card using JSONFileManager
            creditCardStore.addCreditCard(creditCard)
            
            // Dismiss the view
            presentationMode.wrappedValue.dismiss()
        } else {
            // Activar el alert con el mensaje de error
            showAlert = true
        }
    }
    
    private func isValidCreditCard(_ card: CreditCard) -> Bool {
        // Verificar que todos los campos estén completos
        guard !card.cardHolder.isEmpty,
              card.number.count == 19, // 16 dígitos + 3 espacios
              card.expiryDate.count == 5, // "MM/YY"
              (card.cvv.count == 3 || card.cvv.count == 4) else {
            errorMessage = "Please fill in all fields."
            return false
        }

        // Validar la fecha de expiración
        let components = card.expiryDate.split(separator: "/")
        if components.count == 2,
           let month = Int(components[0]),
           let year = Int(components[1]),
           (1...12).contains(month) {
            // Fecha válida si el mes está entre 1 y 12
            return true
        } else {
            errorMessage = "Invalid expiry date. Please use MM/YY format."
            return false
        }
    }
}
