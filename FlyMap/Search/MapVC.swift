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
    
    private func addRoute() {
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 50, y: 100))
//        path.addQuadCurve(to: CGPoint(x: 50, y: 300), controlPoint: CGPoint(x: 300, y: 200))
//
//        let shapeLayer = CAShapeLayer()
//
//        // The Bezier path that we made needs to be converted to
//        // a CGPath before it can be used on a layer.
//        shapeLayer.path = path.cgPath
//
//        // apply other properties related to the path
//        shapeLayer.strokeColor = UIColor.blue.cgColor
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.lineWidth = 1.0
//        shapeLayer.position = CGPoint(x: 10, y: 10)
        
        // add the new layer to our custom view
//        mapView.layer.addSublayer(shapeLayer)
        
        let startCoordinate = CLLocationCoordinate2D(latitude: startCity.latitude, longitude: startCity.longitude)
        let finishCoordinate = CLLocationCoordinate2D(latitude: finishCity.latitude, longitude: finishCity.longitude)
        let myPolyline = MKPolyline(coordinates: [startCoordinate, finishCoordinate], count: 2)
        mapView.addOverlay(myPolyline)
    }
}

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = CurveLineRenderer(overlay: overlay, mapView: mapView)
        renderer.strokeColor = UIColor.green
        renderer.createPath()
        return renderer
    }
}
