//
//  DefaultTextField.swift
//  MoneyMind
//
//  Created by Павел on 30.04.2025.
//

import Foundation
import UIKit

final class DefaultTextField: UITextField {
    // MARK: - Init
    
    init(placeholder: String, textAlignment: NSTextAlignment, keyboardType: UIKeyboardType) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.textAlignment = textAlignment
        self.keyboardType = keyboardType
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        font = Font.subtitle.font
        layer.cornerRadius = Size.cornerRadius
        backgroundColor = .component
        clipsToBounds = true
        heightAnchor.constraint(equalToConstant: Size.fieldHeight).isActive = true
        textColor = .text
        
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: Spacing.medium, height: 0))
        leftViewMode = .always
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: Spacing.medium, height: 0))
        rightViewMode = .always
    }
}
