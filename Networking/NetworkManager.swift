//
//  NetworkManager.swift
//  WeatherLive
//
//  Created by Marika Kalandia on 06.02.26.
//

import Foundation

struct NetworkManager {
    
    static func fetchCountries(completion: @escaping (Result<[Country], Error>) -> Void) {
        // "https://restcountries.com/v3.1/all?fields=name"
        guard let url = URL(string: "https://restcountries.com/v3.1/independent?status=true") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let countries = try JSONDecoder().decode([Country].self, from: data)
                print("\nFetched Countries:")
                completion(.success(countries))
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    static func fetchWeatherDetails(lat: Double, lng: Double, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        // "https://restcountries.com/v3.1/all?fields=name"
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lng)&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let weatherModelData = try JSONDecoder().decode(WeatherModel.self, from: data)
                print("\nFetched weather details:")
                completion(.success(weatherModelData))
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}
