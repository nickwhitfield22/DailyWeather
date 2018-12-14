//
//  WeatherModel.swift
//  DailyWeather
//
//  Created by Nicholas Whitfield on 10/18/18.
//  Copyright © 2018 RandomFacts. All rights reserved.
//

import Foundation
import UIKit

struct DailyWeather {
    let summary: String
    let icon: String
    let data: [WeatherData]
}

struct WeatherData: Codable {
    let summary: String
    let icon: String
    let temperatureLow: Double
    let temperatureHigh: Double
}

enum OuterCodingKeys: String, CodingKey {
    case daily
}

enum InnerCodingKeys: String, CodingKey {
    case summary, icon, data
}

let decoder = JSONDecoder()
extension DailyWeather: Decodable {
    init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: OuterCodingKeys.self)
        let innerContainer = try outerContainer.nestedContainer(keyedBy: InnerCodingKeys.self, forKey: .daily)
        self.summary = try innerContainer.decode(String.self, forKey: .summary)
        self.icon = try innerContainer.decode(String.self, forKey: .icon)
        self.data = try innerContainer.decode([WeatherData].self, forKey: .data)
    }
}

let encoder = JSONEncoder()
extension DailyWeather: Encodable {
    func encode(to encoder: Encoder) throws {
        var outerContainer = encoder.container(keyedBy: OuterCodingKeys.self)
        var innerContainer = outerContainer.nestedContainer(keyedBy: InnerCodingKeys.self, forKey: .daily)
        try innerContainer.encode(summary, forKey: .summary)
        try innerContainer.encode(icon, forKey: .icon)
        try innerContainer.encode(data, forKey: .data)
    }
}



