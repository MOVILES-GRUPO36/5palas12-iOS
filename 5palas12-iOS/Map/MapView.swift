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
    @ObservedObject var restaurantsVM: RestaurantViewModel
    @State private var hasCenteredOnUser = false
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 4.7110, longitude: -74.0721),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    @State private var selectedRestaurant: RestaurantModel? = nil
    @State private var enterTime: Date? = nil // Variable to store the time the view appears
    
    var body: some View {
        VStack {
            LogoView()
                .padding(.all,0)
            ZStack {
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: restaurantsVM.restaurants) { restaurant in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)) {
                        VStack {
                            Image(systemName: "mappin") // Usar un ícono de pin
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.red)
                            Text(restaurant.name) // Muestra el nombre del restaurante
                                .font(.caption)
                                .foregroundColor(Color("FernGreen"))
                        }
                        .onTapGesture {
                            selectedRestaurant = restaurant
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
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
                        RestaurantCardView(restaurant: restaurant)
                    }
                }
            }
            .onTapGesture {
                selectedRestaurant = nil
            }
            .padding(.all,0)
        }
    }
}
