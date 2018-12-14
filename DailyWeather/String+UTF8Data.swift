//
//  String+UTF8Data.swift
//  DailyWeather
//
//  Created by Nicholas Whitfield on 10/20/18.
//  Copyright © 2018 RandomFacts. All rights reserved.
//

import Foundation

extension Data {
    public var stringDescription: String {
        return String(data: self, encoding: .utf8)!
    }
}
