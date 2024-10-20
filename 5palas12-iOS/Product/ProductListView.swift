import SwiftUI

struct ProductListView: View {
    @State var restaurant: RestaurantModel
    @StateObject var productVM: ProductViewModel
    
    init(restaurant: RestaurantModel) {
        _restaurant = State(initialValue: restaurant)
        _productVM = StateObject(wrappedValue: ProductViewModel(restaurant: restaurant))
    }
    
    var body: some View {
        if productVM.products.isEmpty
        {
            Text("No Products Available at the moment")
                .bold()
                .foregroundStyle(.red)
        }
        else{
            VStack(spacing: 0){
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(productVM.products) { product in
                            ProductCardView(product: product)
                        }
                    }
                    .padding(10)
                }
                .background(Color("Timberwolf"))
            }
        }
    }
}
