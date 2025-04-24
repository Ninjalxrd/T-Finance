//
//  Font.swift
//  MoneyMind
//
//  Created by Павел on 13.04.2025.
//

import UIKit

enum Font {
    case title
    case subtitle
    case body
    case button
    case smallTitle
    
    var font: UIFont {
        switch self {
        case .title:
            UIFont.systemFont(ofSize: 36, weight: .bold)
        case .subtitle:
            UIFont.systemFont(ofSize: 16, weight: .medium)
        case .body:
            UIFont.systemFont(ofSize: 8, weight: .regular)
        case .button:
            UIFont.systemFont(ofSize: 16, weight: .bold)
        case .smallTitle:
            UIFont.systemFont(ofSize: 20, weight: .bold)
        }
    }
}
