//
//  CitySearchResource.swift
//  FlyMap
//
//  Created by Ivan Babich on 30/08/2019.
//  Copyright © 2019 Ivan Babich. All rights reserved.
//

import Foundation
import MapKit
import PromiseKit

class CitySearchResource: NSObject, CitySearch {
    private let searchRequest = MKLocalSearch.Request()
    private let completer = MKLocalSearchCompleter()
    
    private var pending = Promise<[String]>.pending()
    
    override init() {
        super.init()
        completer.delegate = self
        completer.filterType = .locationsOnly
    }
    
    func getCitiesTitles(for searchString: String) -> Promise<[String]> {
        pending = Promise<[String]>.pending()
        completer.queryFragment = searchString
        return pending.promise
    }
    
    func getCoordinatesFor(for cityTitle: String) -> Promise<City> {
        searchRequest.naturalLanguageQuery = cityTitle
        let search = MKLocalSearch(request: searchRequest)
        
        return Promise<City> { pending in
            search.start { response, error in
                guard let response = response, let mapItem = response.mapItems.first else {
                    pending.reject(CitySearchError.unknown)
                    return
                }
                pending.fulfill(City(coordinate: mapItem.placemark.coordinate))
            }
        }
    }
}

extension CitySearchResource: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let cities = completer.results.compactMap { $0.title }.filter { $0.contains(",") }
        pending.resolver.fulfill(cities)
    }
}
