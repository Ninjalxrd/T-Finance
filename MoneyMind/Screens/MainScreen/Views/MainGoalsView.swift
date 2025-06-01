//
//  MainGoalsView.swift
//  MoneyMind
//
//  Created by Павел on 18.05.2025.
//

import UIKit
import Combine
import SkeletonView

final class MainGoalsView: UIView {
    // MARK: - Publisher

    private let detailsSubject = PassthroughSubject<Void, Never>()
    var detailsPublisher: AnyPublisher<Void, Never> {
        detailsSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadowAndCorners()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - UI

    private lazy var goalsTitleLabel: UILabel = {
        let label = DefaultLabel(numberOfLines: 1, text: "Цели")
        label.font = Font.smallViewTitle.font
        label.skeletonCornerRadius = CGFloat.skeletonCornerRadius
        label.heightAnchor.constraint(equalToConstant: CGFloat.expenceTitleLabel).isActive = true
        return label
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.isSkeletonable = true
        tableView.skeletonCornerRadius = CGFloat.skeletonCornerRadius
        tableView.register(GoalsTableViewCell.self, forCellReuseIdentifier: GoalsTableViewCell.identifier)
        return tableView
    }()

    private lazy var detailsButton: UIButton = {
        let button = DefaultButton(title: "Подробнее", action: buttonAction)
        button.isSkeletonable = true
        button.heightAnchor.constraint(equalToConstant: CGFloat.buttonHeight).isActive = true
        return button
    }()

    private lazy var buttonAction = UIAction { [weak self] _ in
        self?.detailsSubject.send()
    }
    
    // MARK: - Skeleton

    func showSkeleton() {
        tableView.showAnimatedGradientSkeleton()
        goalsTitleLabel.showAnimatedGradientSkeleton()
        detailsButton.showAnimatedGradientSkeleton()
    }

    func hideSkeleton() {
        tableView.hideSkeleton()
        goalsTitleLabel.hideSkeleton()
        detailsButton.hideSkeleton()
    }

    // MARK: - Private

    private func setupUI() {
        backgroundColor = .background
        layer.cornerRadius = Size.cornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowRadius = Size.cornerRadius / 2
        layer.masksToBounds = false

        addSubview(goalsTitleLabel)
        addSubview(tableView)
        addSubview(detailsButton)

        setupConstraints()
    }

    private func setupConstraints() {
        goalsTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Spacing.small)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(goalsTitleLabel.snp.bottom).offset(Spacing.smallest)
            make.leading.equalToSuperview().offset(Spacing.small)
            make.trailing.equalToSuperview().offset(-Spacing.small)
            make.bottom.equalTo(detailsButton.snp.top).offset(-Spacing.smallest)
        }

        detailsButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Spacing.small)
            make.bottom.trailing.equalToSuperview().offset(-Spacing.small)
        }
    }
    
    private func setupShadowAndCorners() {
        backgroundColor = .background
        layer.cornerRadius = Size.cornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowRadius = Size.cornerRadius / 2
        layer.masksToBounds = false
        clipsToBounds = true
    }
}

private extension CGFloat {
    static let buttonHeight: CGFloat = 56
    static let expenceTitleLabel: CGFloat = 48
    static let skeletonCornerRadius: Float = 8
}
