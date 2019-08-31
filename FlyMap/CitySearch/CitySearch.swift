//
//  CitySearch.swift
//  FlyMap
//
//  Created by Ivan Babich on 30/08/2019.
//  Copyright © 2019 Ivan Babich. All rights reserved.
//

import Foundation
import PromiseKit

protocol CitySearch {
    func getCitiesTitles(for searchString: String) -> Promise<[String]>
    func getCoordinatesFor(for cityTitle: String) -> Promise<City>
}
