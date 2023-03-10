//
//  Extensions.swift
//  theApp
//
//  Created by Robert Zinyatullin on 19.02.2023.
//

import UIKit
import MapKit

extension Int {
    func toMonth() -> String {
        switch self {
        case 1:
            return "января"
        case 2:
            return "февраля"
        case 3:
            return "марта"
        case 4:
            return "апреля"
        case 5:
            return "мая"
        case 6:
            return "июня"
        case 7:
            return "июля"
        case 8:
            return "августа"
        case 9:
            return "сентября"
        case 10:
            return "октября"
        case 11:
            return "ноября"
        case 12:
            return "декабря"
        default:
            return ""
        }
    }
}

extension String {
    func toFormattedDateString() -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = formatter.date(from: self) else {
            return ""
        }
        
        formatter.dateFormat = "MM"
        let month = Int(formatter.string(from: date))?.toMonth() ?? ""
        
        formatter.dateFormat = "dd"
        let day = formatter.string(from: date)
        let formattedDateString = "\(day) \(month)"
        return formattedDateString
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 2500
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
    
    func setCustomCameraZoomRange(_ location: CLLocation) {
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 50000,
            longitudinalMeters: 60000)
        self.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: region),
            animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        self.setCameraZoomRange(zoomRange, animated: true)
    }
    
    
}
