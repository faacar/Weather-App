//
//  WeatherVC.swift
//  Weather App
//
//  Created by Ahmet Acar on 12.12.2020.
//  Copyright © 2020 Ahmet Acar. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherVC: UIViewController {
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        locationManager.delegate = self
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        addSubView()
        layoutUI()
        addTargets()
    }
    
    private func addSubView() {
        view.addSubview(locationButton)
        view.addSubview(searchButton)
        view.addSubview(searchTextField)
        view.addSubview(conditionImageView)
        view.addSubview(temperatureLabel)
        view.addSubview(conditionLabel)
    }
    
    private func addTargets() {
        locationButton.addTarget(self, action: #selector(locationButtonClicked), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
    }


    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.borderStyle = .none
        textField.layer.backgroundColor = UIColor.systemGray.withAlphaComponent(0.3).cgColor
        textField.layer.cornerRadius = 13.0
        return textField
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "location"), for: .normal)
        return button
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        return button
    }()
    
    private lazy var conditionImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "imClear")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .systemGray
        label.text = "24°"
        return label
    }()
    
    private lazy var conditionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.text = "Mostly Cloudy"
        return label
    }()
    
    @objc func locationButtonClicked() {
        locationManager.requestLocation()
    }
    
    @objc func searchButtonClicked() { // olmadi assa delegate sinin oldugun yere tasirsin
        searchTextField.endEditing(true)
    }
    
    private func layoutUI() {
        let padding: CGFloat = 8
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        conditionImageView.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            locationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            locationButton.widthAnchor.constraint(equalToConstant: 30),
            locationButton.heightAnchor.constraint(equalToConstant: 30),
            locationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            searchButton.widthAnchor.constraint(equalToConstant: 30),
            searchButton.heightAnchor.constraint(equalToConstant: 30),
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            
            searchTextField.leadingAnchor.constraint(equalTo: locationButton.trailingAnchor, constant: padding),
            searchTextField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -padding),
            searchTextField.heightAnchor.constraint(equalToConstant: 30),
            searchTextField.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor),
            
            conditionImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            conditionImageView.heightAnchor.constraint(equalToConstant: 220),
            conditionImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: conditionImageView.centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: conditionImageView.bottomAnchor, constant: padding),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 22),
            
            conditionLabel.centerXAnchor.constraint(equalTo: conditionImageView.centerXAnchor),
            conditionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: padding),
            conditionLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
}

//MARK: -Extensions

extension WeatherVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.text = "Type something!"
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
}

extension WeatherVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitute: lat, longitute: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

extension WeatherVC: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManger: WeatherManager, weatherModel: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weatherModel.temperatureString
            self.conditionLabel.text = weatherModel.description
            //self.cityName
            self.conditionImageView.image = UIImage(named: "\(weatherModel.conditionImage)")
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
