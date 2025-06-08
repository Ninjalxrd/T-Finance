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
    case smallViewTitle
    case body
    case bigBody
    case button
    case smallTitle
    case logo
    
    var font: UIFont {
        switch self {
        case .title:
            UIFont(name: "TinkoffSans-Bold", size: 36) ??
            UIFont.systemFont(ofSize: 36, weight: .bold)
        case .smallViewTitle:
            UIFont.systemFont(ofSize: 24, weight: .bold)
        case .subtitle:
            UIFont.systemFont(ofSize: 16, weight: .medium)
        case .body:
            UIFont.systemFont(ofSize: 8, weight: .regular)
        case .bigBody:
            UIFont.systemFont(ofSize: 12, weight: .regular)
        case .button:
            UIFont.systemFont(ofSize: 16, weight: .semibold)
        case .smallTitle:
            UIFont.systemFont(ofSize: 20, weight: .bold)
        case .logo:
            UIFont(name: "TacticSansExtExd-Blk", size: 24) ??
            UIFont.systemFont(ofSize: 24, weight: .black)
        }
    }
}
