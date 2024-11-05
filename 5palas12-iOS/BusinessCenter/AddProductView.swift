import SwiftUI

struct AddProductView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var productVM: ProductViewModel
    @State private var name = ""
    @State private var price = ""
    @State private var categories = ""
    @State private var photo = ""
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Add New Product")
                    .font(.title)
                    .bold()
                
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Price", text: $price)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                
                TextField("Categories (comma separated)", text: $categories)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Photo URL", text: $photo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: addProduct) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Spacer()
            }
            .padding()
            .padding(.top,50)
        }
        .overlay(alignment: .topLeading){
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.accent)
                    Text("Back")
                        .foregroundColor(.accent)
                }
            }.offset(x: 10,y: 18)
            
        }
    }
    
    private func addProduct() {
        guard let priceValue = Double(price) else { return }
        
        let newProduct = ProductModel(
            name: name,
            price: priceValue,
            categories: categories.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
            photo: photo
        )
        
        productVM.addProduct(newProduct) { success in
            if success {
                presentationMode.wrappedValue.dismiss()
            } else {
                print("Error adding product")
            }
        }
    }
}
