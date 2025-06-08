//
//  Theme.swift
//  MoneyMind
//
//  Created by Павел on 08.06.2025.
//

import UIKit

enum Theme: Int {
    case system
    case light
    case dark
    
    func getUserInterfaceStyle() -> UIUserInterfaceStyle {
        switch self {
        case .system:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
