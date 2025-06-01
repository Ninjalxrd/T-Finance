//
//  GoalsTableViewCell.swift
//  MoneyMind
//
//  Created by Павел on 16.05.2025.
//

import SnapKit
import UIKit
import SkeletonView

class GoalsTableViewCell: UITableViewCell {
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSkeleton()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private UI Elements
    
    private lazy var goalName: UILabel = {
        let label = DefaultLabel(numberOfLines: 1, text: "")
        label.text = "Default Skeleton Placeholder"
        label.font = Font.subtitle.font

        return label
    }()
    
    private lazy var goalSumLabel: UILabel = {
        let label = DefaultLabel(numberOfLines: 1, text: "")
        label.text = "Placeholder"
        label.font = Font.subtitle.font

        return label
    }()
    
    private lazy var spacer: UIView = {
        let space = UIView()
        space.setContentHuggingPriority(.defaultLow, for: .horizontal)
        space.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return space
    }()
    
    private lazy var goalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [goalName, spacer, goalSumLabel])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.progress = 0
        progress.trackTintColor = .lightGray
        progress.progressTintColor = UIColor.appBlue
        progress.heightAnchor.constraint(equalToConstant: CGFloat.progressBarHeight).isActive = true
        return progress
    }()
    
    // MARK: - Setup UI
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        isSkeletonable = true
        contentView.isSkeletonable = true
        contentView.addSubview(goalStack)
        contentView.addSubview(progressView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        goalStack.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Spacing.small)
            make.trailing.equalToSuperview().offset(-Spacing.small)
        }
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(goalName.snp.bottom).offset(Spacing.medium)
            make.leading.equalToSuperview().offset(Spacing.small)
            make.bottom.trailing.equalToSuperview().offset(-Spacing.small)
        }
    }
    
    func configureCell(with goal: Goal) {
        goalName.text = goal.name
        goalSumLabel.text =
        "\(String(format: "%.0f", goal.currentAmount))₽ из \(String(format: "%.0f", goal.targetAmount))₽"
        configureProgressBar(current: goal.currentAmount, total: goal.targetAmount)
    }
    
    func configureProgressBar(current: Double, total: Double) {
        let progress = total == 0 ? 0 : Float(current / total)
        progressView.progress = progress
    }
    
    private func setupSkeleton() {
        [
            goalName,
            goalSumLabel,
            progressView,
            goalStack
        ].forEach {
            $0.isSkeletonable = true
        }
    }
}

// MARK: - Extensions

private extension CGFloat {
    static let stackHeight: CGFloat = 48
    static let progressBarHeight: CGFloat = 8
}

extension GoalsTableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
