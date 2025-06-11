//
//  CategoriesCell.swift
//  MoneyMind
//
//  Created by Павел on 03.06.2025.
//

import UIKit
import SnapKit

final class CategoriesCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var iconImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = image.bounds.width / 2
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = DefaultTitleLabel(numberOfLines: 1, text: "Placeholder")
        label.font = Font.subtitle.font
        label.heightAnchor.constraint(equalToConstant: CGFloat.titleLabelHeight).isActive = true
        return label
    }()
    
    private func setupUI() {
        contentView.addSubview(iconImage)
        contentView.addSubview(titleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        iconImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Spacing.medium)
            make.height.width.equalTo(CGFloat.imageSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Spacing.medium)
            make.leading.equalTo(iconImage.snp.trailing).offset(Spacing.medium)
        }
    }
    
    func configureCell(with category: TransactionCategory) {
        titleLabel.text = category.name
    }
    
    func configureIcon(with image: UIImage?) {
        iconImage.image = image ?? UIImage(named: "expenceImage")
    }
}

private extension CGFloat {
    static let imageSize: CGFloat = 48
    static let titleLabelHeight: CGFloat = 43
}

extension CategoriesCell {
    static var identifier: String {
        return String(describing: self)
    }
}
