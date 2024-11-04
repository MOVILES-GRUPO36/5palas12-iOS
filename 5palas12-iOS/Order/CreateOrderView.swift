import SwiftUI

struct CreateOrderView: View {
    @EnvironmentObject var ordersVM: OrdersViewModel
    @State private var userEmail: String = UserDefaults.standard.string(forKey: "currentUserEmail") ?? ""
    @State private var productsInput: String = ""
    @State private var price: String = ""
    @State private var isActive: Bool = true
    @State private var pickUpTime: String = ""
    @State private var showSuccessMessage: Bool = false
    @State private var showErrorMessage: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                LogoView()
                    .padding(.top)
                
                Text("Create New Order")
                    .font(.title)
                    .padding(.bottom, 20)
                
                Form {
                    Section(header: Text("Order Details")) {
                        TextField("User Email", text: $userEmail)
                            .disabled(true)
                        
                        TextField("Products (comma separated)", text: $productsInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Total Price", text: $price)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Toggle("Order Active", isOn: $isActive)
                        
                        TextField("Pickup Time", text: $pickUpTime)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    createOrder()
                }) {
                    Text("Submit Order")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                if showSuccessMessage {
                    Text("Order created successfully!")
                        .foregroundColor(.green)
                        .padding(.top)
                }
                
                if showErrorMessage {
                    Text("Failed to create order. Please try again.")
                        .foregroundColor(.red)
                        .padding(.top)
                }
                
                Spacer()
            }
            .background(Color("Timberwolf"))
            .onAppear {
                userEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? ""
            }
        }
    }
    
    private func createOrder() {
        guard let priceValue = Double(price) else {
            showErrorMessage = true
            return
        }
        
        let products = productsInput.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        ordersVM.createOrder(userEmail: userEmail, products: products, price: priceValue, isActive: isActive, pickUpTime: pickUpTime)
        
        showSuccessMessage = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showSuccessMessage = false
        }
    }
}


