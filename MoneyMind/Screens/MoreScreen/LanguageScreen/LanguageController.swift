//
//  LanguageController.swift
//  MoneyMind
//
//  Created by Павел on 09.06.2025.
//

import UIKit

class LanguageController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private lazy var placeholderLabel: UILabel = {
        let label = DefaultTitleLabel(numberOfLines: 1, text: "В разработке")
        return label
    }()
    
    private func setupUI() {
        view.backgroundColor = .background
        view.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
