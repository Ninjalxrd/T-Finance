//
//  DefaultElemets.swift
//  MoneyMind
//
//  Created by Павел on 25.04.2025.
//
import UIKit

enum DefaultElements {
    static func defaultYellowButton(primaryAction: UIAction?) -> UIButton {
        let defaultButton: UIButton = {
            let button = UIButton(primaryAction: primaryAction)
            button.backgroundColor = .brand
            button.titleLabel?.font = Font.button.font
            button.tintColor = .text
            button.layer.cornerRadius = Size.cornerRadius
            button.clipsToBounds = true
            return button
        }()
        
        return defaultButton
    }
    
    static func defaultTextField() -> UITextField {
        let textField = UITextField()
        textField.font = Font.subtitle.font
        textField.layer.cornerRadius = Size.cornerRadius
        textField.backgroundColor = .component
        textField.clipsToBounds = true
        textField.heightAnchor.constraint(equalToConstant: Size.fieldHeight).isActive = true
        textField.textColor = .text
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Spacing.medium, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: Spacing.medium, height: 0))
        textField.rightViewMode = .always
        
        return textField
    }
    
    static func defaultTitleLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Font.title.font
        label.textColor = .text
        return label
    }
}
