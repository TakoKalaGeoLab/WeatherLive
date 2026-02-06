//
//  HomeViewController.swift
//  WeatherLive
//
//  Created by Marika Kalandia on 06.02.26.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        fetchCountries()
    }
    
    private func fetchCountries() {
        NetworkManager.fetchCountries { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let countries):
                DispatchQueue.main.async {
                    let countriesList = Array(countries.dropFirst(100))
                    NetworkManager.fetchWeatherDetails(
                        lat: countries.first?.latlng?[0] ?? 0,
                        lng: countries.first?.latlng?[1] ?? 0
                    ) { result in
                        switch result {
                        case .success(let model):
                            print(model)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            case .failure(let error):
                print("Failed to fetch countries: \(error.localizedDescription)")
            }
        }
    }
}
