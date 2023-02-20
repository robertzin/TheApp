//
//  MapLocation.swift
//  theApp
//
//  Created by Robert Zinyatullin on 20.02.2023.
//

import MapKit

class MapLocation: NSObject, MKAnnotation {
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    
    init(
        locationName: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.locationName = locationName
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    static let antalyaMapAnnotations = [
        MapLocation(locationName: "Hadrian's Gate", coordinate: CLLocationCoordinate2D(latitude: 36.88523, longitude: 30.70851)),
        MapLocation(locationName: "Kesik Minaret", coordinate: CLLocationCoordinate2D(latitude: 36.89056, longitude: 30.707029)),
        MapLocation(locationName: "Hidirlik Tower", coordinate: CLLocationCoordinate2D(latitude: 36.881389, longitude: 30.703611)),
        MapLocation(locationName: "Antalya Saat Kulesi", coordinate: CLLocationCoordinate2D(latitude: 36.886944, longitude: 30.705833)),
        MapLocation(locationName: "Ramada Plaza Hotel", coordinate: CLLocationCoordinate2D(latitude: 36.88022, longitude: 30.70871))
    ]
}
