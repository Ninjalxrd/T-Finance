//
//  DistributionCollectionViewCell.swift
//  MoneyMind
//
//  Created by Павел on 17.04.2025.
//

import UIKit

final class DistributionCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties

    var isPicked: Bool = false
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private lazy var categoryStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, iconImage])
        stack.layer.cornerRadius = Size.cornerRadius
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        stack.spacing = Spacing.smallest
        return stack
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Font.subtitle.font
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private lazy var iconImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.tintColor = .white
        return image
    }()
    
    // MARK: - Setup UI
    
    private func setupUI() {
        contentView.addSubview(categoryStackView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        categoryStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Configure Cell Method
    
    func configure(with category: Category, isPicked: Bool) {
        nameLabel.text = category.name
        self.isPicked = isPicked
        categoryStackView.backgroundColor = isPicked ?
        UIColor(hex: category.backgroundColor)
        : .nonPicked
        iconImage.image = isPicked ? UIImage(systemName: "xmark") : UIImage(systemName: "plus")
    }
}
    // MARK: - Extension

extension DistributionCollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
