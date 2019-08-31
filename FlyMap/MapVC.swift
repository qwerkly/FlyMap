//
//  ViewController.swift
//  FlyMap
//
//  Created by Ivan Babich on 24/08/2019.
//  Copyright © 2019 Ivan Babich. All rights reserved.
//

import UIKit
import MapKit
import IVBezierPathRenderer
import simd

class MapVC: UIViewController {
    @IBOutlet private weak var mapView: MKMapView!
    
    private var startCity: City! //= City(city: "Moscow", latitude: 55.751244, longitude: 37.618423)
    private var finishCity: City! //= City(city: "Istambul", latitude: 41.015137, longitude: 28.979530)
    
    private let annotation = MKPointAnnotation()
    
    private var timer = Timer()
    
    convenience init(startCity: City, finishCity: City) {
        self.init()
        self.startCity = startCity
        self.finishCity = finishCity
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPolyline()
        movePosition()
    }
    
    private func addPolyline() {
        annotation.coordinate = startCity.coordinate
        mapView.addAnnotation(annotation)
        
        let locations = [
            startCity.coordinate,
            finishCity.coordinate
        ]

        let polyline = MKPolyline(coordinates: locations, count: locations.count)
        mapView.addOverlay(polyline)
        mapView.setCenter(locations[0], animated: false)
    }
    
    private func movePosition() {
        timer = .scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            UIView.animate(withDuration: 4, animations: {
                self.annotation.coordinate = self.finishCity.coordinate
            })
        }
    }
}

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .red
        renderer.lineWidth = 2
        return renderer
    }
}
