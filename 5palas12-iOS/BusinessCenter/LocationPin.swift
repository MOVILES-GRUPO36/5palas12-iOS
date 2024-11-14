//
//  LocationPin.swift
//  5palas12-iOS
//
//  Created by santiago on 13/11/24.
//

import CoreLocation

struct LocationPin: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
}
