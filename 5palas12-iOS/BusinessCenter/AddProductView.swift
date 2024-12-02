import SwiftUI

struct AddProductView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var productVM: ProductViewModel
    @State private var name = ""
    @State private var price = ""
    @State private var selectedCategoryIndex = 0
    @State private var quantity = ""
    @State private var photo = ""
    @EnvironmentObject var userVM: UserViewModel  // Use EnvironmentObject for UserViewModel

    
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
                
                Picker("Category", selection: $selectedCategoryIndex) {
                    ForEach(0..<categoriesList.count, id: \.self) { index in
                        Text(categoriesList[index].name)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                TextField("Quantity (kg)", text: $quantity)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                
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
            .padding(.top, 50)
        }
        .overlay(alignment: .topLeading) {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.accent)
                    Text("Back")
                        .foregroundColor(.accent)
                }
            }
            .offset(x: 10, y: 18)
        }
    }
    
    private func addProduct() {
        guard let priceValue = Double(price),
              let quantityValue = Double(quantity) else { return }
        
        let selectedCategory = categoriesList[selectedCategoryIndex]
        let co2Emissions = quantityValue * selectedCategory.co2PerKg
        
        guard let restaurant = userVM.userData?.restaurant else {
                    print("Restaurant data is not available")
                    return
                }
        
        let newProduct = ProductModel(
            name: name,
            price: priceValue,
            category: selectedCategory.name,
            photo: photo,
            co2Emissions: co2Emissions,
            weight: quantityValue,
            restaurant: restaurant
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
