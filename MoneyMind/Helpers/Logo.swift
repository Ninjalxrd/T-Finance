//
//  Logo.swift
//  MoneyMind
//
//  Created by Павел on 23.04.2025.
//
import UIKit

final class Logo: UIView {
    // MARK: - Private Properties

    private lazy var logoImage: UIImageView = {
        let image = UIImageView()
        image.image = .logo
        image.contentMode = .scaleAspectFit
        image.frame = .init(x: 0, y: 0, width: CGFloat.logoWidth, height: CGFloat.logoHeight)
        return image
    }()
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.text = "ФИНАНСЫ"
        label.textColor = .text
        label.numberOfLines = 1
        label.font = Font.logo.font
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [logoImage, logoLabel])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = Spacing.smallest
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        addSubview(stack)
        setupConstraints()
    }
    
    private func setupConstraints() {
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

private extension CGFloat {
    static let logoWidth: CGFloat = 57
    static let logoHeight: CGFloat = 53
}
