//
//  DefaultButton.swift
//  MoneyMind
//
//  Created by Павел on 30.04.2025.
//

import Foundation
import UIKit

final class DefaultButton: UIButton {
    // MARK: - Init
    
    init(title: String, action: UIAction) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.addAction(action, for: .touchUpInside)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        backgroundColor = .brand
        setTitleColor(.text, for: .normal)
        titleLabel?.font = Font.button.font
        layer.cornerRadius = Size.cornerRadius
        clipsToBounds = true
    }
}
