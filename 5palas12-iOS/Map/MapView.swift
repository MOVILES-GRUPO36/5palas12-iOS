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
    @StateObject private var locationManager = LocationMapManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 4.7110, longitude: -74.0721),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    @State private var selectedRestaurant: RestaurantModel? = nil

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0){
                LogoView()
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.15)
                    .padding(0)
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
                    locationManager.requestLocation()
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
                        RestaurantDetailView(restaurant: restaurant)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.4)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .padding()
                            .onTapGesture {
                                selectedRestaurant = nil
                            }
                    }
                }
            }
            .onTapGesture {
                selectedRestaurant = nil
            }
        }
        }
    }
}
