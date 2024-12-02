//
//  BusinessEditViewView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 1/12/24.
//

import SwiftUI
import MapKit

struct BusinessEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var restaurant: RestaurantModel

    @State private var name: String = ""
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var photo: String = ""
    @State private var categories: String = ""
    @State private var description: String = ""
    @State private var rating: String = ""
    @State private var address: String = ""
    @State private var distance: String = ""
    @State private var cachedImage: UIImage?
    @EnvironmentObject var restaurantVM: RestaurantViewModel

    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var showingLocationPicker = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Restaurant Details")) {
                    TextField("Photo URL", text: $photo)
                    TextField("Categories (comma-separated)", text: $categories)
                    TextField("Description", text: $description)
                    TextField("Rating", text: $rating)
                        .keyboardType(.decimalPad)
                    TextField("Address", text: $address)
                    TextField("Distance (optional)", text: $distance)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Location")) {
                    if let location = selectedLocation {
                        Map(coordinateRegion: .constant(MKCoordinateRegion(
                            center: location,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )), annotationItems: [LocationPin(coordinate: location)]) { location in
                            MapPin(coordinate: location.coordinate, tint: .red)
                        }
                        .frame(height: 200)
                        .cornerRadius(10)

                        Text("Latitude: \(location.latitude), Longitude: \(location.longitude)")
                            .padding(.top, 5)

                        Button("Change Location") {
                            showingLocationPicker.toggle()
                        }
                    } else {
                        Button("Set Location") {
                            showingLocationPicker.toggle()
                        }
                    }
                }

                Section {
                    Button(action: saveChanges) {
                        Text("Save Changes")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.fernGreen)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationBarTitle("Edit Restaurant", displayMode: .inline)
            .onAppear(perform: populateFields)
            .sheet(isPresented: $showingLocationPicker) {
                LocationPickerView(selectedLocation: $selectedLocation)
            }
        }
    }

    private func populateFields() {
        name = restaurant.name
        latitude = "\(restaurant.latitude)"
        longitude = "\(restaurant.longitude)"
        photo = restaurant.photo
        categories = restaurant.categories.joined(separator: ", ")
        description = restaurant.description
        rating = "\(restaurant.rating)"
        address = restaurant.address
        distance = restaurant.distance != nil ? "\(restaurant.distance!)" : ""
        cachedImage = restaurant.cachedImage
        selectedLocation = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
    }

    private func saveChanges() {
        guard let latitudeValue = Double(latitude),
              let longitudeValue = Double(longitude),
              let ratingValue = Double(rating) else {
            print("Datos inválidos")
            return
        }

        restaurant.name = name
        restaurant.latitude = latitudeValue
        restaurant.longitude = longitudeValue
        restaurant.photo = photo
        restaurant.categories = categories.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        restaurant.description = description
        restaurant.rating = ratingValue
        restaurant.address = address
        restaurant.distance = Double(distance) ?? nil
        restaurant.cachedImage = cachedImage
        
        restaurantVM.editRestaurant(restaurant)
        let restaurantSA = RestaurantSA()
        restaurantSA.updateRestaurant(restaurant) { result in
            switch result {
            case .success:
                print("Restaurante actualizado exitosamente en Firebase")
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                }
            case .failure(let error):
                print("Error al actualizar el restaurante: \(error.localizedDescription)")
            }
        }
    }
}
