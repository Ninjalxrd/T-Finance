//
//  Expence.swift
//  MoneyMind
//
//  Created by Павел on 04.05.2025.
//
import UIKit

struct Expence: Identifiable, Codable {
    let id: Int
    let name: String
    let date: Date
    let category: TransactionCategory
    let amount: Double
    let description: String
}
