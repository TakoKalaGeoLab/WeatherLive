//
//  HomeViewController.swift
//  WeatherLive
//
//  Created by Marika Kalandia on 06.02.26.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        checkCurrentLocationStatus()
        setupLocationManager()
    }
    
    private func setupUI() {
        view.backgroundColor = .gray
    }
    
    private func checkCurrentLocationStatus() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            currentLocation = locationManager.location
            getCurrentLocationWeather()
        default:
            return
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func getCurrentLocationWeather() {
        let lat = currentLocation?.coordinate.latitude ?? 37.3230
        let lng = currentLocation?.coordinate.longitude ?? 122.0322
        NetworkManager.fetchWeatherDetails(lat: lat, lng: lng) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    print(model)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI() {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            currentLocation = locationManager.location
            getCurrentLocationWeather()
        default:
            return
        }
    }
}
