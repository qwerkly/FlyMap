//
//  CurveLineRenderer.swift
//  FlyMap
//
//  Created by Ivan Babich on 26/08/2019.
//  Copyright © 2019 Ivan Babich. All rights reserved.
//

import Foundation
import MapKit

class CurveLineRenderer: MKPolylineRenderer {
    var mapView: MKMapView!
    
    override init(overlay: MKOverlay) {
        super.init(overlay: overlay)
    }
    
    convenience init(overlay: MKOverlay, mapView: MKMapView) {
        self.init(overlay: overlay)
        self.mapView = mapView
//        createPath()
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let theMapRect = overlay.boundingMapRect
        
        guard mapRect.intersects(theMapRect) || self.path != nil else { return }
        
        //Do some logic if needed.
        
        guard let overlay = overlay as? MKMultiPoint else { return }
        
        var points = [CGPoint]()
        for i in 0..<overlay.pointCount {
            points.append(point(for: overlay.points()[i]))
        }
        if points.count == 0 { return }
        
        //Create and draw your path
        let path = CGMutablePath()
        path.move(to: self.path.currentPoint)
        
//        path.addLine(to: CGPoint(x: 0.0, y: 16708800.09227179))
        path.addLines(between: points)
        
        context.addPath(path)
        
        //Customise it
        context.setStrokeColor(UIColor.red.cgColor)
        context.setFillColor(UIColor.black.cgColor)
        context.setLineWidth(2.0)
        context.drawPath(using: .eoFillStroke)
        
        //And apply it
        context.strokePath()
    }
    
//    override func createPath() {
//        super.createPath()
//        guard let overlay = overlay as? MKMultiPoint else { return }
//
//        var points = [MKMapPoint]()
//        for i in 0..<overlay.pointCount {
//            points.append(overlay.points()[i])
//        }
//        if points.count == 0 { return }
    
//        MK
        
//        let path = UIBezierPath()
//        let point = mapView.convert(points[0].coordinate, toPointTo: mapView)
//        let endPoint = mapView.convert(points[1].coordinate, toPointTo: mapView)
//        var center = centerBetween(coordinate1: points[0].coordinate, coordinate2: points[1].coordinate)
//        center.latitude += 20
//        let centerCor = mapView.convert(center, toPointTo: mapView)
//        print(point)
//        print(endPoint)
//        path.move(to: point)
//        path.addLine(to: centerCor)
        
//        strokeColor = .red
//        path.addQuadCurve(to: endPoint, controlPoint: centerCor)
        
//        self.path = path.cgPath
//        UIBezierPath *path = [UIBezierPath bezierPath];
//
//        for (NSValue *cgPointValue in cgPoints) {
//            if ([cgPoints indexOfObject:cgPointValue] == 0) {
//                [path moveToPoint:cgPointValue.CGPointValue];
//            }else{
//                [path addLineToPoint:cgPointValue.CGPointValue];
//            }
//        }
//
//        self.path = self.tension.floatValue==0?[path bezierFlat].CGPath:[path bezierCardinalWithTension:self.tension.floatValue].CGPath;
//    }
    
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
