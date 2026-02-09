//
//  WeatherModel.swift
//  WeatherLive
//
//  Created by Marika Kalandia on 06.02.26.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Decodable {
    let latitude: Double?
    let longitude: Double?
    let generationtimeMS: Double?
    let utcOffsetSeconds: Int?
    let timezone: String?
    let timezoneAbbreviation: String?
    let elevation: Int?
    let currentUnits: Units?
    let current: Current?
    let hourlyUnits: Units?
    let hourly: Hourly?

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case currentUnits = "current_units"
        case current
        case hourlyUnits = "hourly_units"
        case hourly
    }
}

// MARK: - Current
struct Current: Decodable {
    let time: String?
    let interval: Int?
    let temperature2M: Double?
    let windSpeed10M: Double?

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2M = "temperature_2m"
        case windSpeed10M = "wind_speed_10m"
    }
}

// MARK: - Units
struct Units: Decodable {
    let time: String
    let interval: String?
    let temperature2M, windSpeed10M: String
    let relativeHumidity2M: String?

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2M = "temperature_2m"
        case windSpeed10M = "wind_speed_10m"
        case relativeHumidity2M = "relative_humidity_2m"
    }
}

// MARK: - Hourly
struct Hourly: Decodable {
    let time: [String]
    let temperature2M: [Double]
    let relativeHumidity2M: [Int]
    let windSpeed10M: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case relativeHumidity2M = "relative_humidity_2m"
        case windSpeed10M = "wind_speed_10m"
    }
}
