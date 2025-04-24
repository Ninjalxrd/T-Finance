//
//  Color.swift
//  MoneyMind
//
//  Created by Павел on 13.04.2025.
//
import UIKit

extension UIColor {
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        let length = hexSanitized.count
        
        guard length == 6 || length == 8 else { return nil }
        
        var rgbValue: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgbValue) else { return nil }
        
        if length == 6 {
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            let red = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            let green = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            let blue = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
            let alpha = CGFloat(rgbValue & 0x000000FF) / 255.0
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
}
