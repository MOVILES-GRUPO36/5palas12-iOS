//
//  CreateBusinessView.swift
//  5palas12-iOS
//
//  Created by santiago on 4/11/24.
//

import SwiftUI
import FirebaseAuth
import CoreLocation

struct CreateBusinessView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: BusinessCenterViewModel  // Injected ViewModel

    // Temporary properties to store form inputs
    @State private var name: String = ""
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var photo: String = ""
    @State private var categories: String = ""
    @State private var description: String = ""
    @State private var rating: String = ""
    @State private var address: String = ""
    @State private var restaurant: RestaurantModel?
    
    private let restaurantDAO = RestaurantDAO()
    private let userDAO = UserDAO()
    @State private var userEmail: String = ""
    
    @ObservedObject private var locationManager = LocationManager()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Business Details")) {
                    TextField("Name", text: $name)
                    TextField("Latitude", text: $latitude)
                        .keyboardType(.decimalPad)
                    TextField("Longitude", text: $longitude)
                        .keyboardType(.decimalPad)
                    TextField("Photo URL", text: $photo)
                    TextField("Categories (comma-separated)", text: $categories)
                    TextField("Description", text: $description)
                    TextField("Rating", text: $rating)
                        .keyboardType(.decimalPad)
                    TextField("Address", text: $address)
                }
                
                Button(action: saveBusiness) {
                    Text("Save Business")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .navigationBarTitle("Create a Business", displayMode: .inline)
            .onAppear {
                locationManager.requestLocation()
                
                if let currentUser = Auth.auth().currentUser {
                    userEmail = currentUser.email ?? ""
                }
            }
            .onReceive(locationManager.$lastLocation) { location in
                if let location = location {
                    latitude = "\(location.coordinate.latitude)"
                    longitude = "\(location.coordinate.longitude)"
                }
            }
        }
    }
    
    private func saveBusiness() {
        guard let latitudeValue = Double(latitude),
              let longitudeValue = Double(longitude),
              let ratingValue = Double(rating) else {
            return
        }
        
        restaurant = RestaurantModel(
            name: name,
            latitude: latitudeValue,
            longitude: longitudeValue,
            photo: photo,
            categories: categories.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) },
            description: description,
            rating: ratingValue,
            address: address
        )
        
        restaurantDAO.addRestaurant(restaurant!) { result in
            switch result {
            case .success():
                userDAO.addRestaurantToUser(email: userEmail, restaurantName: name) { userResult in
                    switch userResult {
                    case .success():
                        viewModel.businessExists = true  // Update the view model
                    case .failure(let error):
                        print("Failed to add restaurant to user: \(error.localizedDescription)")
                    }
                }
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                print("Failed to save restaurant: \(error.localizedDescription)")
            }
        }
    }
}
