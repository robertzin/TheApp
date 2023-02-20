//
//  MapViewController.swift
//  theApp
//
//  Created by Robert Zinyatullin on 17.02.2023.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    private lazy var mapKit: MKMapView = {
        let map = MKMapView()
        let initialLocation = CLLocation(latitude: 36.884804, longitude: 30.704044)
        map.centerToLocation(initialLocation)
        map.setCustomCameraZoomRange(initialLocation)
        map.addAnnotations(MapLocation.antalyaMapAnnotations)
        map.register(MapLocationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = Constants.Colors.backgroundColor
        view.addSubview(mapKit)
    }
    
    private func setupConstraints() {
        mapKit.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
