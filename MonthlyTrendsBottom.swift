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
    let dailyCalsLimit: DailyCalsLimit
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let breakfast, brunch, lunch, eveningSnack, dinner: [[String: Meal]]

    enum CodingKeys: String, CodingKey {
        case breakfast = "Breakfast"
        case brunch = "Brunch"
        case lunch = "Lunch"
        case eveningSnack = "Evening Snack"
        case dinner = "Dinner"
    }
}

// MARK: - Breakfast
struct Meal: Codable {
    let cals: Int
    let imgs: [String]

    enum CodingKeys: String, CodingKey {
        case cals = "Cals"
        case imgs = "Imgs"
    }
}

// MARK: - DailyCalsLimit
struct DailyCalsLimit: Codable {
    let breakfast, brunch, lunch, eveningSnack: Int
    let dinner: Int

    enum CodingKeys: String, CodingKey {
        case breakfast = "Breakfast"
        case brunch = "Brunch"
        case lunch = "Lunch"
        case eveningSnack = "Evening Snack"
        case dinner = "Dinner"
    }
}

enum Img: String, Codable {
    case empty = "-"
}


