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
        view.backgroundColor = .background
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Font.smallTitle.font
        label.textColor = .text
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Font.subtitle.font
        label.textColor = .secondaryText
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private lazy var accumulatedAmountLabel: UILabel = {
        let label = UILabel()
        label.font = Font.subtitle.font
        label.textColor = .text
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()

    private lazy var ofLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text
        label.font = Font.subtitle.font
        label.text = "Из"
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = Font.subtitle.font
        label.textColor = .text
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private lazy var amountStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [accumulatedAmountLabel, ofLabel, amountLabel])
        stack.axis = .vertical
        stack.spacing = Spacing.smallest
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        return stack
    }()
    
    // MARK: - Setup UI
    
    private func setupUI() {
        contentView.clipsToBounds = false
        clipsToBounds = false
        backgroundColor = .clear
        contentView.addSubview(backView)
        backView.addSubview(nameLabel)
        backView.addSubview(descriptionLabel)
        backView.addSubview(amountStackView)
        setupConstaints()
        setupShadows(backView)
    }
    
    private func setupShadows(_ view: UIView) {
        view.layer.cornerRadius = Size.cornerRadius
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowRadius = Size.cornerRadius / 2
        view.layer.masksToBounds = false
    }
    
    private func setupConstaints() {
        backView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Spacing.medium)
            make.leading.equalToSuperview().offset(Spacing.medium)
            make.trailing.equalToSuperview().offset(-Spacing.medium)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Spacing.medium)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(Spacing.small)
            make.leading.equalToSuperview().offset(Spacing.medium)
        }
        
        amountStackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(Spacing.medium)
        }
    }
    
    // MARK: - Public Methods
    
    func configureCell(with goal: Goal) {
        nameLabel.text = goal.name
        descriptionLabel.text = goal.description
        accumulatedAmountLabel.text = "\(Int(goal.accumulatedAmount)) ₽"
        amountLabel.text = "\(Int(goal.amount)) ₽"
    }
}

extension GoalCell {
    static var identifier: String {
        return String(describing: self)
    }
}
