//
//  RestaurantDetailView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 12/10/24.
//

import SwiftUI

struct RestaurantDetailView: View {
    @State var restaurant: RestaurantModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView{
            VStack(spacing: 0){
                LogoView()
                    .padding(.all,0)
                ScrollView{
                    VStack(spacing: 0){
                        AsyncImage(url: URL(string: restaurant.photo)){ image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame( height: (250))
                                .clipped()
                            
                        } placeholder: {
                            ProgressView()
                                .progressViewStyle(LinearProgressViewStyle())
                        }
                        ZStack{
                            Rectangle()
                                .foregroundColor(Color("Timberwolf") )
                                .scaledToFill()
                            VStack(alignment: .leading, spacing: 6) {
                                Text(restaurant.name)
                                    .font(.system(size:32))
                                    .fontWeight(.bold)
                                Text("\(restaurant.categories.joined(separator: " - "))")
                                    .opacity(0.5)
                                HStack(spacing: 2) {
                                    ForEach(0..<5) { index in
                                        if index < Int(restaurant.rating) {
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.white)
                                                .padding(4)
                                                .background(Color("FernGreen"))
                                                .cornerRadius(4)
                                        } else if index < Int(restaurant.rating + 0.5) {
                                            Image(systemName: "star.leadinghalf.filled")
                                                .foregroundColor(.white)
                                                .padding(4)
                                                .background(Color("FernGreen"))
                                                .cornerRadius(4)
                                        } else {
                                            Image(systemName: "star")
                                                .foregroundColor(.white)
                                                .padding(4)
                                                .background(Color("FernGreen"))
                                                .cornerRadius(4)
                                        }
                                    }
                                }
                                
                                Text(restaurant.description)
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                                    .padding(.vertical, 10)
                                Spacer()
                            }.padding(.top, 10)
                            
                        }
                    }
                }
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
    

