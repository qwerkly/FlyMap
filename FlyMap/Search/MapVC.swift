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
    
    private lazy var startCoordinate = CLLocationCoordinate2D(latitude: startCity.latitude, longitude: startCity.longitude)
    private lazy var finishCoordinate = CLLocationCoordinate2D(latitude: finishCity.latitude, longitude: finishCity.longitude)
    
    private var polyline: MKPolyline!
    private let annotation = MKPointAnnotation()
    
    private var timer = Timer()
    
    convenience init(startCity: City, finishCity: City) {
        self.init()
        self.startCity = startCity
        self.finishCity = finishCity
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        annotation.coordinate = startCoordinate
        mapView.addAnnotation(annotation)
        addPolyline()
        movePosition()
    }
    
    private func addPolyline() {
        let startCoordinate = CLLocationCoordinate2D(latitude: startCity.latitude, longitude: startCity.longitude)
        let endCoordinate = CLLocationCoordinate2D(latitude: finishCity.latitude, longitude: finishCity.longitude)
        
        let locations = [
            startCoordinate,
            endCoordinate
        ]
        
        polyline = MKPolyline(coordinates: locations, count: locations.count)
        mapView.addOverlay(polyline)
        mapView.setCenter(locations[0], animated: false)
    }
    
    private func movePosition() {
        timer = .scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] _ in
            UIView.animate(withDuration: 4, animations: {
                guard let self = self else { return }
                self.annotation.coordinate = self.finishCoordinate
            })
        }
    }
        
        //    private func deg2rad(_ number: Double) -> Double {
        //        return number * .pi / 180
        //    }
        
        //    private func addRoute() {
        //        let f1 = deg2rad(startCoordinate.latitude)
        //        let l1 = deg2rad(startCoordinate.longitude)
        //        let f2 = deg2rad(finishCoordinate.latitude)
        //        let l2 = deg2rad(finishCoordinate.longitude)
        //        let numberOfPoints = 20
        //        let delta = (l1 - l2) / Double(numberOfPoints - 1)
        //        var location = [CLLocationCoordinate2D]()
        //        for i in 0..<numberOfPoints {
        //            let l = l1 - delta * i
        //            f = (atan())
        //        }
        ////        var center = centerBetween(coordinate1: startCoordinate, coordinate2: finishCoordinate)
        ////        center.latitude += 1
        //
        //        let myPolyline = MKPolyline(coordinates: [startCoordinate, finishCoordinate], count: 4)
        ////        myPolyline.accessibilityPath
        //        mapView.addOverlay(myPolyline)
        //    }
}

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
//        let renderer = IVBezierPathRenderer(overlay: overlay)
        renderer.strokeColor = .red
        renderer.lineWidth = 2
//        renderer.tension = 2.5
        return renderer
    }
}
