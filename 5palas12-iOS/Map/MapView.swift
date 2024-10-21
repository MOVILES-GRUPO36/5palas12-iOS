//
//  MapView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 30/09/24.
//

import Foundation
import MapKit
import SwiftUI

struct MapView: View {
    @EnvironmentObject var restaurantsVM: RestaurantViewModel
    @State private var hasCenteredOnUser = false
    @State private var showDetails = false
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 4.7110, longitude: -74.0721),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    @State private var selectedRestaurant: RestaurantModel? = nil
    @State private var enterTime: Date? = nil // Variable to store the time the view appears
    
    var body: some View {
        NavigationView {
            
            VStack (spacing: 0){
                LogoView()
                    .padding(.all,0)
                ZStack {
                    Map(coordinateRegion: $region,
                        showsUserLocation: true,
                        annotationItems: restaurantsVM.restaurants,
                        annotationContent: { restaurant in
                        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)) {
                            MapAnnotationView()
                                .shadow(radius: 10)
                                .onTapGesture {
                                    selectedRestaurant = restaurant
                                }
                        }
                    })
                    .onAppear {
                        enterTime = Date() // Almacenar el tiempo de entrada
                        locationManager.requestLocation()
                    }
                    .onDisappear {
                        // Calcular cuánto tiempo ha estado el usuario e–n la vista
                        if let enterTime = enterTime {
                            let elapsedTime = Date().timeIntervalSince(enterTime)
                            print("El usuario estuvo en la vista por \(elapsedTime) segundos.")
                        }
                    }
                    .onReceive(locationManager.$lastLocation) { newLocation in
                        if let location = newLocation, !hasCenteredOnUser {
                            region = MKCoordinateRegion(
                                center: location.coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                            )
                            hasCenteredOnUser = true
                        }
                    }
                    
                    if let restaurant = selectedRestaurant {
                        VStack {
                            Spacer()
                            withAnimation(.easeInOut) {
                                RestaurantCardView(restaurant: restaurant)
                                    .padding(.bottom, 10)
                                    .onTapGesture {
                                        showDetails.toggle()
                                    }
                            }
                            
                        }
                    }
                }
                .padding(.all,0)
            }
        }.sheet(isPresented: $showDetails) {
            RestaurantDetailView(restaurant: selectedRestaurant!)
        }
    }
}
