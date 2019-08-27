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

class MapVC: UIViewController {
    @IBOutlet private weak var mapView: MKMapView!
    
    private var startCity: City! = City(city: "Moscow", latitude: 55.751244, longitude: 37.618423)
    private var finishCity: City! = City(city: "Istambul", latitude: 41.015137, longitude: 28.979530)
    
    convenience init(startCity: City, finishCity: City) {
        self.init()
        self.startCity = startCity
        self.finishCity = finishCity
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        addRoute()
    }
    
    private func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    private func addRoute() {
        let startCoordinate = CLLocationCoordinate2D(latitude: startCity.latitude, longitude: startCity.longitude)
        let finishCoordinate = CLLocationCoordinate2D(latitude: finishCity.latitude, longitude: finishCity.longitude)
        let f1 = deg2rad(startCoordinate.latitude)
        let l1 = deg2rad(startCoordinate.longitude)
        let f2 = deg2rad(finishCoordinate.latitude)
        let l2 = deg2rad(finishCoordinate.longitude)
        let numberOfPoints = 20
        let delta = (l1 - l2) / Double(numberOfPoints - 1)
        var location = [CLLocationCoordinate2D]()
        for i in 0..<numberOfPoints {
            let l = l1 - delta * i
            f = (atan())
        }
//        var center = centerBetween(coordinate1: startCoordinate, coordinate2: finishCoordinate)
//        center.latitude += 1
        
        let myPolyline = MKPolyline(coordinates: [startCoordinate, finishCoordinate], count: 4)
//        myPolyline.accessibilityPath
        mapView.addOverlay(myPolyline)
    }
    
    private func centerBetween(coordinate1: CLLocationCoordinate2D, coordinate2: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let lon1 = coordinate1.longitude * .pi / 180
        let lon2 = coordinate2.longitude * .pi / 100
        
        let lat1 = coordinate1.latitude * .pi / 180
        let lat2 = coordinate2.latitude * .pi / 100
        
        let dLon = lon2 - lon1
        
        let x = cos(lat2) * cos(dLon)
        let y = cos(lat2) * sin(dLon)
        
        let lat3 = atan2(sin(lat1) + sin(lat2), sqrt(cos(lat1) + x) * (cos(lat1) + x) + y * y)
        let lon3 = lon1 + atan2(y, cos(lat1) + x)
        
        let center = CLLocationCoordinate2D(latitude: lat3 * 180 / .pi, longitude: lon3 * 180 / .pi)
        
        return center
    }
}

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = CurveLineRenderer(overlay: overlay, mapView: mapView)
//        renderer.strokeColor = .red
        return renderer
    }
}
