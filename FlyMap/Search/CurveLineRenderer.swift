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
    }
    
    override func createPath() {
        guard let overlay = overlay as? MKMultiPoint else { return }
        
        var points = [MKMapPoint]()
        for i in 0..<overlay.pointCount {
            points.append(overlay.points()[i])
        }
        if points.count == 0 { return }
        
        let path = UIBezierPath()
        let point = mapView.convert(points[0].coordinate, toPointTo: mapView)
        let endPoint = mapView.convert(points[1].coordinate, toPointTo: mapView)
        print(point)
        print(endPoint)
        path.move(to: point)
        path.addQuadCurve(to: endPoint, controlPoint: CGPoint(x: 200, y: 200))
        
        self.path = path.cgPath
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
    }
}
