//
//  Logo.swift
//  MoneyMind
//
//  Created by Павел on 23.04.2025.
//
import UIKit

final class Logo: UIView {
    // MARK: - Private Properties

    private var logoImage: UIImageView {
        let image = UIImageView()
        image.image = .logo
        image.contentMode = .scaleAspectFit
        image.frame = .init(x: 0, y: 0, width: 57, height: 53)
        return image
    }
    
    private var logoLabel: UILabel {
        let label = UILabel()
        label.text = "ФИНАНСЫ"
        label.textColor = .text
        label.numberOfLines = 1
        label.font = Font.logo.font
        return label
    }
    
    // MARK: - Properties

    var logoStackView: UIStackView {
        let stack = UIStackView(arrangedSubviews: [logoImage, logoLabel])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = Spacing.smallest
        return stack
    }
}
