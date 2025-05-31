//
//  ExpensesTableViewCell.swift
//  MoneyMind
//
//  Created by Павел on 04.05.2025.
//

import SnapKit
import UIKit
import SkeletonView

class ExpencesTableViewCell: UITableViewCell {
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupSkeleton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private UI Elements
    
    private lazy var categoryImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = image.bounds.width / 2
        image.clipsToBounds = true
        image.heightAnchor.constraint(equalToConstant: CGFloat.imageSize).isActive = true
        image.widthAnchor.constraint(equalToConstant: CGFloat.imageSize).isActive = true
        return image
    }()
    
    private lazy var expencePlaceLabel: UILabel = {
        let label = DefaultLabel(numberOfLines: 1, text: "")
        label.text = "Default Skeleton Placeholder"
        label.font = Font.subtitle.font
        return label
    }()
    
    private lazy var expenceCategoryLabel: UILabel = {
        let label = DefaultLabel(numberOfLines: 1, text: "")
        label.font = Font.bigBody.font
        label.text = "Default Skeleton Placeholder"
        label.textColor = .secondaryText
        return label
    }()
    
    private lazy var expenceSumLabel: UILabel = {
        let label = DefaultLabel(numberOfLines: 1, text: "")
        label.font = Font.subtitle.font
        label.text = "Placeholder"
        return label
    }()
    
    private lazy var expencePlaceAndCategoryStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [expencePlaceLabel, expenceCategoryLabel])
        stack.axis = .vertical
        stack.spacing = Spacing.small
        stack.distribution = .fill
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var spacer: UIView = {
        let space = UIView()
        space.setContentHuggingPriority(.defaultLow, for: .horizontal)
        space.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return space
    }()
    
    private lazy var expenceTextStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            expencePlaceAndCategoryStack,
            spacer,
            expenceSumLabel
        ])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.heightAnchor.constraint(equalToConstant: CGFloat.stackHeight).isActive = true
        return stack
    }()
    
    // MARK: - Setup UI
    
    private func setupUI() {
        selectionStyle = .none
        isSkeletonable = true
        contentView.isSkeletonable = true
        contentView.addSubview(categoryImage)
        contentView.addSubview(expenceTextStack)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        categoryImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Spacing.small)
        }
        
        expenceTextStack.snp.makeConstraints { make in
            make.leading.equalTo(categoryImage.snp.trailing).offset(Spacing.small)
            make.top.equalToSuperview().offset(Spacing.small)
            make.trailing.equalToSuperview().offset(-Spacing.small)
        }
    }
    
    func configureCell(with expence: Expence) {
        expencePlaceLabel.text = expence.name
        expenceCategoryLabel.text = expence.category.name
        expenceSumLabel.text = "-\(Int(expence.amount.rounded())) ₽"
    }
    
    func configureCellIcon(with image: UIImage?) {
        categoryImage.image = image ?? UIImage(named: "expenceImage")
    }
    
    private func setupSkeleton() {
        [
            categoryImage,
            expenceSumLabel,
            expencePlaceLabel,
            expenceCategoryLabel,
            expenceTextStack,
            expencePlaceAndCategoryStack
        ].forEach {
            $0.isSkeletonable = true
            $0.skeletonCornerRadius = Float(CGFloat.imageSize / 2)
        }
    }
}

// MARK: - Extensions

private extension CGFloat {
    static let imageSize: CGFloat = 48
    static let stackHeight: CGFloat = 48
}

extension ExpencesTableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
