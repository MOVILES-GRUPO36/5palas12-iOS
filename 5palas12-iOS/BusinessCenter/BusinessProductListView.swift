//
//  BusinessProductListView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 4/11/24.
//

import SwiftUI

struct BusinessProductListView: View {
    @StateObject var productVM: ProductViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isAddingProduct = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                LogoView()
                    .padding(.all, 0)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(productVM.products) { product in
                            BusinessProductCardView(product: product)
                        }
                    }
                    .padding(10)
                }
                .background(Color("Timberwolf"))
            }
            .navigationBarItems(
                leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("Timberwolf"))
                        Text("Back")
                            .foregroundColor(Color("Timberwolf"))
                    }
                },
                trailing: Button(action: {
                    isAddingProduct = true
                }) {
                    HStack {
                        Text("Add")
                        Image(systemName: "plus")
                    }
                    .foregroundColor(Color("Timberwolf"))
                }
            )
            .sheet(isPresented: $isAddingProduct) {
                AddProductView(productVM: productVM)
            }
        }
    }
}
