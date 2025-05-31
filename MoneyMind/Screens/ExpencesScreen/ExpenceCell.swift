//
//  ExpenceCell.swift
//  MoneyMind
//
//  Created by Павел on 28.05.2025.
//

import UIKit
import SnapKit

final class ExpenceCell: UITableViewCell {
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var shopLabel: UILabel = {
        let label = DefaultLabel(numberOfLines: 1, text: "")
        label.font = Font.subtitle.font
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = DefaultLabel(numberOfLines: 1, text: "")
        label.font = Font.subtitle.font
        label.textColor = .gray
        return label
    }()
    
    private lazy var sumLabel: UILabel = {
        let label = DefaultLabel(numberOfLines: 1, text: "")
        label.textAlignment = .right
        label.font = Font.subtitle.font
        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [shopLabel, categoryLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()

    private func setupUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(textStackView)
        contentView.addSubview(sumLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Spacing.medium)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(CGFloat.imageSize)
        }
        
        textStackView.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(Spacing.medium)
            make.centerY.equalToSuperview()
        }
        
        sumLabel.snp.makeConstraints { make in
            make.leading.equalTo(textStackView.snp.trailing).offset(Spacing.medium)
            make.trailing.equalToSuperview().offset(-Spacing.medium)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with expence: Expence) {
        shopLabel.text = expence.name
        categoryLabel.text = expence.category.name
        sumLabel.text = "-\(Int(expence.amount.rounded())) ₽"
    }
    
    func configureCellIcon(with image: UIImage?) {
        iconImageView.image = image ?? UIImage(named: "expenceImage")
    }
}

extension ExpenceCell {
    static var identifier: String {
        return String(describing: self)
    }
}

private extension CGFloat {
    static let imageSize: CGFloat = 48
}
