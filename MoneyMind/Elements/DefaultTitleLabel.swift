//
//  DefaultLabel.swift
//  MoneyMind
//
//  Created by Павел on 30.04.2025.
//

import Foundation
import UIKit

final class DefaultTitleLabel: UILabel {
    // MARK: - Init
    
    init(numberOfLines: Int, text: String) {
        super.init(frame: .zero)
        self.numberOfLines = numberOfLines
        self.text = text
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        textAlignment = .left
        font = Font.title.font
        textColor = .text
    }
}
