//
//  RestaurantDetailView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 12/10/24.
//

import SwiftUI

struct RestaurantDetailView: View {
    @State var restaurant: RestaurantModel
    @EnvironmentObject var cartVM: CartViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView{
            VStack(spacing: 0){
                LogoView()
                    .padding(.all,0)
                ScrollView{
                    VStack(spacing: 0){
                        if let cachedImage = restaurant.cachedImage {
                            Image(uiImage: cachedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 100)
                                .clipped()
                        } else {
                            ProgressView()
                                .progressViewStyle(LinearProgressViewStyle())
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            Text(restaurant.name)
                                .font(.system(size:32))
                                .fontWeight(.bold)
                            Text("\(restaurant.categories.joined(separator: " - "))")
                                .opacity(0.5)
                            RatingView(rating: restaurant.rating)
                            Text(restaurant.description)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.vertical, 10)
                            Divider()
                            ProductListView(restaurant: restaurant)
                                .padding(.vertical, 15)
                            Spacer()
                            
                            
                        }.padding([.top,.horizontal], 10)
                        
                        
                    }
                    .background(Color("Timberwolf"))
                }.background(Color("Timberwolf"))
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
    }}


