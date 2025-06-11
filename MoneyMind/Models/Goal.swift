//
//  Goal.swift
//  MoneyMind
//
//  Created by Павел on 16.05.2025.
//

import Foundation

struct Goal: Codable {
    let id: Int
    let name: String
    let term: String
    let amount: Double
    let accumulatedAmount: Double
    let description: String
}
