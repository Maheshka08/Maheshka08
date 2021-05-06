//
//  MonthlyTrendsTop.swift
//  Tweak and Eat
//
//  Created by Mehera on 04/05/21.
//  Copyright © 2021 Purpleteal. All rights reserved.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let monthlyTrendsTop = try? newJSONDecoder().decode(MonthlyTrendsTop.self, from: jsonData)

import Foundation

// MARK: - MonthlyTrendsTop
struct MonthlyTrendsTop: Codable {
    let callStatus: String
    let data: [[String: Int?]]
}
