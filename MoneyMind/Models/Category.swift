//
//  Category.swift
//  MoneyMind
//
//  Created by Павел on 17.04.2025.
//

import UIKit

struct Category: Codable {
    var id: Int
    var name: String
    var backgroundColor: String
    var percent: Int
    var money: Int
    var isPicked: Bool
    var notificationLimit: Int = 90
}
