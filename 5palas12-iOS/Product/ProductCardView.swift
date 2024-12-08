import SwiftUI

struct ProductCardView: View {
    @EnvironmentObject var cartVM: CartViewModel
    var product: ProductModel
    
    @State private var showConfirmation = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: product.photo)) { phase in
                    switch phase {
                    case .empty:
                        Image(systemName: "fork.knife")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 150)
                            .foregroundColor(.fernGreen)
                    case .success(let downloadedImage):
                        downloadedImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 150)
                            .clipped()
                    case .failure:
                        Image(systemName: "fork.knife")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 150)
                            .foregroundColor(.fernGreen)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(product.name)
                        .font(.headline)
                    
                    Text(product.category)
                        .opacity(0.5)
                    
                    Text("Weight: \(product.weight, specifier: "%.2f") kg")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("CO2 Emissions: \(product.co2Emissions, specifier: "%.2f") kg")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding([.leading, .bottom, .trailing])
                
                HStack {
                    Spacer()
                    Button {
                        cartVM.addProduct(product)
                        withAnimation {
                            showConfirmation = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showConfirmation = false
                            }
                        }
                    } label: {
                        Text("$" + product.price.formatted())
                            .bold()
                            .padding(.all, 8)
                            .foregroundColor(.white)
                            .background(Color("FernGreen"))
                            .cornerRadius(8)
                    }
                    .padding(.trailing)
                }
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
            
            if showConfirmation {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Product added to cart!")
                            .font(.subheadline)
                            .bold()
                            .padding(10)
                            .foregroundColor(.white)
                            .background(Color.green.opacity(0.9))
                            .cornerRadius(8)
                            .shadow(radius: 5)
                        Spacer()
                    }
                    .padding(.bottom, 16) 
                }
                .transition(.opacity)
            }
        }
    }
}
