//
//  WeatherDataModel.swift
//  WeatherLive
//
//  Created by Marika Kalandia on 10.02.26.
//

import Foundation

struct WeatherDataResponse: Codable {
    let cities: [CityWeather]
}

// MARK: - City
struct CityWeather: Codable {
    let id: Int
    let city: String
    let current: CurrentWeather
    let hourly: [HourlyWeather]
    let weekly: [WeeklyWeather]
}

// MARK: - Current
struct CurrentWeather: Codable {
    let temperature: Int
    let condition: String
    let backgroundImageURL: String
    let high, low, uvIndex: Int

    enum CodingKeys: String, CodingKey {
        case temperature, condition
        case backgroundImageURL = "backgroundImageUrl"
        case high, low, uvIndex
    }
}

// MARK: - Hourly
struct HourlyWeather: Codable {
    let time: Time
    let temperature: Int
    let iconURL: String

    enum CodingKeys: String, CodingKey {
        case time, temperature
        case iconURL = "iconUrl"
    }
}

enum Time: String, Codable {
    case now = "Now"
}

// MARK: - Weekly
struct WeeklyWeather: Codable {
    let day: Day
    let high, low: Int
    let iconURL: String

    enum CodingKeys: String, CodingKey {
        case day, high, low
        case iconURL = "iconUrl"
    }
}

enum Day: String, Codable {
    case mon = "Mon"
}



enum WeatherCondition: String, Decodable {
    case sunny
    case fair
    case cloudy
    case partlyCloudy
    case rainy
    case storm
    case snow
    case fog
}
