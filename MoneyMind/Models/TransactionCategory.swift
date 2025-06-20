//
//  TransactionCategory.swift
//  MoneyMind
//
//  Created by Павел on 28.05.2025.
//

struct TransactionCategory: Codable {
    var id: Int
    var name: String
    var color: String
    var icon: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case color
        case icon = "iconPath"
    }
}
