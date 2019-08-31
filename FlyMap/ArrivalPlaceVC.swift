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
    @IBOutlet private weak var tableView: UITableView!
    
    private let citySearch: CitySearch = CitySearchResource()
    private var cities = [String]() {
        didSet { tableView.reloadData() }
    }
    
    private var startCity: String? {
        didSet { startCityTextField.text = startCity }
    }
    private var finishCity: String? {
        didSet { finishCityTextField.text = finishCity }
    }
    
    private func clearCurrentTextField() {
        if startCityTextField.isFirstResponder {
            startCity = nil
        } else {
            finishCity = nil
        }
    }
    
    private func setValueForCurrentTextField(at index: Int) {
        if index >= cities.count { return }
        if startCityTextField.isFirstResponder {
            startCity = cities[index]
        } else {
            finishCity = cities[index]
        }
    }
    
    private func search() {
        guard let startCity = startCity, let finishCity = finishCity else { return }
        _ = citySearch.getCoordinatesFor(for: startCity).then { startCity in
            self.citySearch.getCoordinatesFor(for: finishCity).done { finishCity in
                self.show(MapVC(startCity: startCity, finishCity: finishCity), sender: nil)
            }
        }
    }
    
    @IBAction func searchPressed() {
        search()
    }
}

extension ArrivalPlaceVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = cities[indexPath.row]
        return cell
    }
}

extension ArrivalPlaceVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setValueForCurrentTextField(at: indexPath.row)
        if startCityTextField.isFirstResponder {
            startCityTextField.resignFirstResponder()
        } else {
            finishCityTextField.resignFirstResponder()
        }
        cities = []
    }
}

extension ArrivalPlaceVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(range)
        print(string)
        guard !string.isEmpty else {
            cities = []
            self.clearCurrentTextField()
            return true
        }
        citySearch.getCitiesTitles(for: textField.text!)
            .done { self.cities = $0 }
            .catch { print($0.localizedDescription) }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if cities.isEmpty { clearCurrentTextField() }
        else { setValueForCurrentTextField(at: 0) }
        textField.resignFirstResponder()
        return true
    }
}
