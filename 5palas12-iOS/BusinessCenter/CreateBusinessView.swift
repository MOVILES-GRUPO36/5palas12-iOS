//
//  CreateBusinessView.swift
//  5palas12-iOS
//
//  Created by santiago on 4/11/24.
//

import SwiftUI
import FirebaseAuth
import CoreLocation
import MapKit

struct CreateBusinessView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: BusinessCenterViewModel

    @State private var name: String = ""
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var photo: String = ""
    @State private var categories: String = ""
    @State private var description: String = ""
    @State private var rating: String = ""
    @State private var address: String = ""
    @State private var restaurant: RestaurantModel?
    
    private let restaurantDAO = RestaurantSA()
    private let userDAO = UserDAO()
    @State private var userEmail: String = ""
    @EnvironmentObject var userVM: UserViewModel
    
    @ObservedObject private var locationManager = LocationManager()

    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var showingLocationPicker = false
    @State private var enterTime:Date? = nil
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Business Details")) {
                    TextField("Name", text: $name)
                    TextField("Photo URL", text: $photo)
                    TextField("Categories (comma-separated)", text: $categories)
                    TextField("Description", text: $description)
                    TextField("Rating", text: $rating)
                        .keyboardType(.decimalPad)
                    TextField("Address", text: $address)
                }
                
                Section(header: Text("Location")) {
                    if let location = selectedLocation {
                        Text("Location Selected")
                            .foregroundColor(.green)
                        
                        Map(coordinateRegion: .constant(MKCoordinateRegion(
                            center: selectedLocation ?? CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default location
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )), annotationItems: [LocationPin(coordinate: selectedLocation ?? CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))]) { location in
                            MapPin(coordinate: location.coordinate, tint: .red)
                        }
                        .frame(height: 200)
                        .cornerRadius(10)
                        .padding(.top, 10)
                        .disabled(true)
                        
                        Text("Latitude: \(location.latitude), Longitude: \(location.longitude)")
                            .foregroundColor(.black)
                            .padding(.top, 5)
                        
                        Button(action: { showingLocationPicker.toggle() }) {
                            Text("Change Location")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    } else {
                        Text("Location not chosen")
                            .foregroundColor(.red)
                        
                        HStack {
                            Button(action: useCurrentLocation) {
                                Text("Use Current Location")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }

                            Button(action: { showingLocationPicker.toggle() }) {
                                Text("Choose Location Manually")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.fernGreen)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                Button(action: saveBusiness) {
                    Text("Save Business")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.fernGreen)
                        .cornerRadius(8)
                }
            }
            
            .navigationBarTitle("Create a Business", displayMode: .inline)
            .onAppear {
                locationManager.requestLocation()
                enterTime = Date()
                if let currentUser = Auth.auth().currentUser {
                    userEmail = currentUser.email ?? ""
                }
            }
            .onDisappear {
                if let enterTime = enterTime {
                    let elapsedTime = Date().timeIntervalSince(enterTime)
                    print("User was in the view for \(elapsedTime) seconds.")
                    
                    FirebaseLogger.shared.logTimeFirebase(viewName: "CreateBusinessView", timeSpent: elapsedTime)
                }
            }
            .sheet(isPresented: $showingLocationPicker) {
                LocationPickerView(selectedLocation: $selectedLocation)
            }
        }
        .background(Color.timberwolf)
    }
    
    private func useCurrentLocation() {
        // Use the current location from the location manager
        if let currentLocation = locationManager.lastLocation {
            selectedLocation = currentLocation.coordinate
            latitude = "\(currentLocation.coordinate.latitude)"
            longitude = "\(currentLocation.coordinate.longitude)"
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
            latitude: Double(selectedLocation?.latitude ?? 0),
            longitude: Double(selectedLocation?.longitude ?? 0),
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
                        viewModel.businessExists = true
                        userVM.userData?.restaurant = restaurant!.name
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
