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
        mapView.setCenter(centerBetween(coordinate1: startCity.coordinate, coordinate2: finishCity.coordinate), animated: false)
    }
    
    private func centerBetween(coordinate1: CLLocationCoordinate2D, coordinate2: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let lon1 = coordinate1.longitude * .pi / 180
        let lon2 = coordinate2.longitude * .pi / 180
        
        let lat1 = coordinate1.latitude * .pi / 180
        let lat2 = coordinate2.latitude * .pi / 180
        
        let dLon = lon2 - lon1
        
        let x = cos(lat2) * cos(dLon)
        let y = cos(lat2) * sin(dLon)
        
        let lat3 = atan2(sin(lat1) + sin(lat2), sqrt(cos(lat1) + x) * (cos(lat1) + x) + y * y)
        let lon3 = lon1 + atan2(y, cos(lat1) + x)
        
        let center = CLLocationCoordinate2D(latitude: lat3 * 180 / .pi, longitude: lon3 * 180 / .pi)
        
        return center
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
