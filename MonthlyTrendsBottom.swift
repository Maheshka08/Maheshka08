//
//  MonthlyTrendsBottom.swift
//  Tweak and Eat
//
//  Created by Mehera on 03/05/21.
//  Copyright © 2021 Purpleteal. All rights reserved.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let monthlyTrendsBottom = try? newJSONDecoder().decode(MonthlyTrendsBottom.self, from: jsonData)

import Foundation

// MARK: - MonthlyTrendsBottom
struct MonthlyTrendsBottom: Codable {
    let callStatus: String
    let data: TrendsBottom
}

// MARK: - DataClass
struct TrendsBottom: Codable {
    let breakfast, brunch, lunch, eveningSnack, dinner: [[String: [String: [String]]]]

    enum CodingKeys: String, CodingKey {
        case breakfast = "Breakfast"
        case brunch = "Brunch"
        case lunch = "Lunch"
        case eveningSnack = "Evening Snack"
        case dinner = "Dinner"
    }
}
