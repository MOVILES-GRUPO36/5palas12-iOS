//
//  LocationPickerView.swift
//  5palas12-iOS
//
//  Created by santiago on 13/11/24.
//

import SwiftUI
import MapKit

struct LocationPickerView: View {
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @State private var mapRegion: MKCoordinateRegion
    @State private var userSelectedLocation: CLLocationCoordinate2D?
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @Environment(\.presentationMode) var presentationMode  // To close the sheet

    // Create state variables for latitude and longitude
    @State private var latitude: Double
    @State private var longitude: Double

    init(selectedLocation: Binding<CLLocationCoordinate2D?>) {
        _selectedLocation = selectedLocation
        _mapRegion = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default location (San Francisco)
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
        _latitude = State(initialValue: 37.7749)  // Default latitude
        _longitude = State(initialValue: -122.4194)  // Default longitude
    }

    var body: some View {
        ZStack(alignment: .top) {
            // Map view with dynamic size using GeometryReader
            GeometryReader { geometry in
                Map(coordinateRegion: $mapRegion,
                    showsUserLocation: true,
                    userTrackingMode: $userTrackingMode,
                    annotationItems: userSelectedLocation != nil ? [LocationPin(coordinate: userSelectedLocation!)] : [LocationPin(coordinate: mapRegion.center)]) { location in
                        MapPin(coordinate: location.coordinate, tint: .red)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height) // Make map fill the available space
            }
            .edgesIgnoringSafeArea(.all)  // Make sure map takes all available space

            // Header with a close button (X)
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Close the sheet
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                }
            }
            .padding()  // Padding to ensure it is at the top-right corner

            // Location Action Buttons
            VStack {
                Spacer()
                
                HStack {
                    Button(action: {
                        // This button is used for either setting or reselection
                        if let location = userSelectedLocation {
                            selectedLocation = location // Set the location to the binding
                            presentationMode.wrappedValue.dismiss() // Optionally close after setting the location
                        }
                    }) {
                        Text("Set Location")
                            .foregroundColor(.white)
                            .padding()
                            .background(.fernGreen)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        selectedLocation = nil
                        userSelectedLocation = nil // Clear the location
                    }) {
                        Text("Clear Location")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            // Initialize the userSelectedLocation when the view appears
            self.userSelectedLocation = mapRegion.center
        }
        .onChange(of: mapRegion.center.latitude) { newLatitude in
            // Update latitude if it has changed
            self.latitude = newLatitude
            updateUserSelectedLocation()
        }
        .onChange(of: mapRegion.center.longitude) { newLongitude in
            // Update longitude if it has changed
            self.longitude = newLongitude
            updateUserSelectedLocation()
        }
    }

    // Custom method to update the user-selected location
    func updateUserSelectedLocation() {
        userSelectedLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
