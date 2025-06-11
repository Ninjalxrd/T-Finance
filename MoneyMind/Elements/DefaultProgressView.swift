//
//  DefaultProgressView.swift
//  MoneyMind
//
//  Created by Павел on 08.06.2025.
//

import UIKit

final class DefaultProgressView: UIProgressView {
    // MARK: - Init
    
    init(progressViewStyle: UIProgressView.Style) {
        super.init(frame: .zero)
        self.progressViewStyle = progressViewStyle
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        progress = 0
        trackTintColor = .lightGray
        progressTintColor = UIColor.appBlue
        heightAnchor.constraint(equalToConstant: CGFloat.progressBarHeight).isActive = true
    }
}

private extension CGFloat {
    static let progressBarHeight: CGFloat = 8
}
