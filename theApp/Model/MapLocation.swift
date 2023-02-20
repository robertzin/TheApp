//
//  MapLocation.swift
//  theApp
//
//  Created by Robert Zinyatullin on 20.02.2023.
//

import MapKit

class MapLocation: NSObject, MKAnnotation {
    var title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    
    init(
        title: String?,
        locationName: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    static let antalyaMapAnnotations = [
        MapLocation(title: "Hadrian's Gate", locationName: "Muratpaşa", coordinate: CLLocationCoordinate2D(latitude: 36.88523, longitude: 30.70851)),
        MapLocation(title: "Kesik Minaret", locationName: "Kaleiçi", coordinate: CLLocationCoordinate2D(latitude: 36.89056, longitude: 30.707029)),
        MapLocation(title: "Hidirlik Tower", locationName: "Karaalioglu Park", coordinate: CLLocationCoordinate2D(latitude: 36.881389, longitude: 30.703611)),
        MapLocation(title: "Antalya Saat Kulesi", locationName: "Antalya", coordinate: CLLocationCoordinate2D(latitude: 36.886944, longitude: 30.705833)),
        MapLocation(title: "Ramada Plaza Hotel", locationName: "Muratpaşa", coordinate: CLLocationCoordinate2D(latitude: 36.88022, longitude: 30.70871))
    ]
}

class MapLocationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard newValue is MapLocation else {
                return
            }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            image = UIImage(named: "mapLocationLogo")!
        }
    }
}

