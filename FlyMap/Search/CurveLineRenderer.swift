//
//  CurveLineRenderer.swift
//  FlyMap
//
//  Created by Ivan Babich on 26/08/2019.
//  Copyright © 2019 Ivan Babich. All rights reserved.
//

import Foundation
import MapKit

class CurveLineRenderer: MKOverlayRenderer {
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        //Create and draw your path
        context.move(to: context.currentPointOfPath)
//        centerBetween(coordinate1: <#T##CLLocationCoordinate2D#>, coordinate2: <#T##CLLocationCoordinate2D#>)
//        context.addArc(center: <#T##CGPoint#>, radius: <#T##CGFloat#>, startAngle: <#T##CGFloat#>, endAngle: <#T##CGFloat#>, clockwise: <#T##Bool#>)
//        context.addPath(path)
        
        //Customise it
        context.setStrokeColor(UIColor.red.cgColor)
        context.setFillColor(UIColor.black.cgColor)
        context.setLineWidth(2.0)
        context.drawPath(using: .eoFillStroke)
        
        //And apply it
        context.strokePath()
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
