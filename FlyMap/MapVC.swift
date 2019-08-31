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
    private var center: CLLocationCoordinate2D!
    
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
        addPolyline()
        movePosition()
    }
    
    private func addPolyline() {
        annotation.coordinate = startCity.coordinate
        mapView.addAnnotation(annotation)
        
        let start = mapView.convert(startCity.coordinate, toPointTo: mapView)
        let end = mapView.convert(finishCity.coordinate, toPointTo: mapView)
        
        let x3 = 400 * cos(atan(abs((start.x - end.x) / (start.y - end.y))) + (start.x + end.x) / 2)
        let y3 = 400 * sin(atan(abs((start.x - end.x) / (start.y - end.y))) + (start.y + end.y) / 2)
        
        center = mapView.convert(CGPoint(x: x3, y: y3), toCoordinateFrom: mapView)
        
        let locations = [
            startCity.coordinate,
            center!,
            finishCity.coordinate
        ]

        polyline = MKPolyline(coordinates: locations, count: locations.count)
        mapView.addOverlay(polyline)
        mapView.setCenter(locations[0], animated: false)
    }
    
    private func movePosition() {
        timer = .scheduledTimer(withTimeInterval: 2.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            UIView.animate(withDuration: 2, animations: {
                self.annotation.coordinate = self.center
            }, completion: { _ in
                UIView.animate(withDuration: 2, animations: {
                    self.annotation.coordinate = self.finishCity.coordinate
                })
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
//        let renderer = MKPolylineRenderer(overlay: overlay)
        let renderer = IVBezierPathRenderer(overlay: overlay)
        renderer.strokeColor = .red
        renderer.lineWidth = 2
//        print(renderer.polyline.points())
        renderer.tension = 2.5
        return renderer
    }
}
