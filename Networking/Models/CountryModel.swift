//
//  CountryModel.swift
//  WeatherLive
//
//  Created by Marika Kalandia on 06.02.26.
//

import Foundation

struct Country: Decodable {
    let name: Name?
    let capital: [String]?
    let latlng: [Double]?
}

extension Country {
    struct Name: Decodable {
        let common: String?
    }
}
