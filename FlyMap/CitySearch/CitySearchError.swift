//
//  CitySearchError.swift
//  FlyMap
//
//  Created by Ivan Babich on 30/08/2019.
//  Copyright © 2019 Ivan Babich. All rights reserved.
//

import Foundation

enum CitySearchError: Error {
    case unknown
    
    var description: String {
        switch self {
        case .unknown:
            return "НЕизвестная ошибка"
        }
    }
}
