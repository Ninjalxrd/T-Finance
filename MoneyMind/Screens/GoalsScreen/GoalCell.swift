//
//  GoalCell.swift
//  MoneyMind
//
//  Created by Павел on 06.06.2025.
//

import UIKit

class GoalCell: UICollectionViewCell {
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements

    private lazy var backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Size.cornerRadius
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowRadius = Size.cornerRadius / 2
        view.layer.masksToBounds = false
        view.heightAnchor.constraint(equalToConstant: CGFloat.viewHeight).isActive = true
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Font.subtitle.font
        label.textColor = .text
        label.numberOfLines = 1
        label.textAlignment = .left
        label.heightAnchor.constraint(equalToConstant: CGFloat.labelHeight).isActive = true
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Font.body.font
        label.textColor = .secondaryText
        label.numberOfLines = 1
        label.textAlignment = .left
        label.heightAnchor.constraint(equalToConstant: CGFloat.labelHeight).isActive = true
        return label
    }()
    
    private lazy var sumLabel: UILabel = {
        let label = UILabel()
        label.font = Font.subtitle.font
        label.textColor = .text
        label.numberOfLines = 1
        label.textAlignment = .left
        label.heightAnchor.constraint(equalToConstant: CGFloat.labelHeight).isActive = true
        return label
    }()
    
    // MARK: - Setup UI
    
    private func setupUI() {
        contentView.addSubview(backView)
        backView.addSubview(nameLabel)
        backView.addSubview(descriptionLabel)
        backView.addSubview(sumLabel)
        setupConstaints()
    }
    
    private func setupConstaints() {
        backView.snp.makeConstraints {
            $0.edges.centerX.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Spacing.medium)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(Spacing.medium)
            make.leading.equalToSuperview().offset(Spacing.medium)
        }
        
        sumLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Spacing.medium)
            make.trailing.equalToSuperview().offset(-Spacing.medium)
        }
    }
}

private extension CGFloat {
    static let viewHeight: CGFloat = 150
    static let labelHeight: CGFloat = 56
}

extension GoalCell {
    static var identifier: String {
        return String(describing: self)
    }
}
