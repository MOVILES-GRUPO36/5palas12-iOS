//
//  DeleteBusinessView.swift
//  5palas12-iOS
//
//  Created by santiago on 13/11/24.
//

import SwiftUI
import FirebaseAuth

struct DeleteBusinessView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: BusinessCenterViewModel
    
    // Restaurant information to be deleted
    @State private var restaurant: RestaurantModel?
    @State private var userEmail: String = ""
    @State private var userRestaurant: String = ""
    @State private var showAlert = false

    private let restaurantDAO = RestaurantSA()
    private let userDAO = UserDAO()
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var restaurantVM: RestaurantViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let restaurant = restaurant {
                    Text("Are you sure you wish to delete your restaurant \"\(restaurant.name)\"?")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    Text("Restaurant not found.")
                        .foregroundColor(.red)
                }
                
                HStack {
                    Button(action: deleteBusiness) {
                        Text("Yes, I wish to delete it")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("No, cancel")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarTitle("Delete Business", displayMode: .inline)
            .onAppear {
                if userVM.userData?.email != nil && userVM.userData?.email != "" {
                    userRestaurant = userVM.userData?.restaurant ?? "no restaurant"
                    print(userRestaurant)
                }
                fetchRestaurantDetails()
            }
        }
    }
    
    // Function to fetch restaurant details for deletion (mocked for now)
    private func fetchRestaurantDetails() {
        restaurant = RestaurantModel(
            name: userRestaurant,
            latitude: 37.7749,
            longitude: -122.4194,
            photo: "sample.jpg",
            categories: ["American", "Fast Food"],
            description: "Delicious food",
            rating: 4.5,
            address: "123 Sample St, San Francisco, CA"
        )
    }

    private func deleteBusiness() {
//        guard let restaurant = restaurant else {
//            return
//        }
//        
//        // Delete restaurant from the database
//        restaurantDAO.deleteRestaurant(restaurant) { result in
//            switch result {
//            case .success():

//                userDAO.removeRestaurantFromUser(email: userEmail, restaurantName: restaurant.name) { userResult in
//                    switch userResult {
//                    case .success():
//                        viewModel.businessExists = false
//                    case .failure(let error):
//                        print("Failed to remove restaurant from user: \(error.localizedDescription)")
//                    }
//                }
//                presentationMode.wrappedValue.dismiss()
//            case .failure(let error):
//                print("Failed to delete restaurant: \(error.localizedDescription)")
//            }
//        }
    }
}
