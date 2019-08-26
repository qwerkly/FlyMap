//
//  ArrivalPlaceVC.swift
//  FlyMap
//
//  Created by Ivan Babich on 25/08/2019.
//  Copyright © 2019 Ivan Babich. All rights reserved.
//

import UIKit

class ArrivalPlaceVC: UIViewController {
    @IBOutlet private weak var startCityTextField: UITextField!
    @IBOutlet private weak var finishCityTextField: UITextField!
    
    @IBAction func searchPressed() {
        let startCity = City(city: "Moscow", latitude: 0.2, longitude: 0.2)
        let endCity = City(city: "Moscow", latitude: 0.2, longitude: 0.2)
        show(MapVC(startCity: startCity, finishCity: endCity), sender: nil)
    }
}

extension ArrivalPlaceVC: UITextFieldDelegate {
    
}
