//
//  MainExpencesView.swift
//  MoneyMind
//
//  Created by Павел on 18.05.2025.
//

import UIKit
import SkeletonView
import Combine

final class MainExpenсesView: UIView {
    // MARK: - Publisher
    
    private let detailsTappedSubject = PassthroughSubject<Void, Never>()
    var detailsTappedPublisher: AnyPublisher<Void, Never> {
        detailsTappedSubject.eraseToAnyPublisher()
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

    // MARK: - UI Elements
    
    private(set) lazy var titleLabel: UILabel = {
        let label = DefaultTitleLabel(numberOfLines: 1, text: "Последние")
        label.font = Font.smallViewTitle.font
        label.skeletonCornerRadius = CGFloat.skeletonCornerRadius
        label.heightAnchor.constraint(equalToConstant: CGFloat.expenceTitleLabel).isActive = true
        return label
    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.isSkeletonable = true
        tableView.skeletonCornerRadius = CGFloat.skeletonCornerRadius
        tableView.register(ExpencesTableViewCell.self, forCellReuseIdentifier: ExpencesTableViewCell.identifier)
        return tableView
    }()
    
    private(set) lazy var detailsButton: UIButton = {
        let button = DefaultButton(title: "Подробнее", action: detailsAction)
        button.heightAnchor.constraint(equalToConstant: CGFloat.buttonHeight).isActive = true
        return button
    }()
    
    private lazy var detailsAction = UIAction { [weak self] _ in
        self?.detailsTappedSubject.send()
    }

    // MARK: - Skeleton Control

    func showSkeleton() {
        titleLabel.showAnimatedGradientSkeleton()
        tableView.showAnimatedGradientSkeleton()
        detailsButton.showAnimatedGradientSkeleton()
    }

    func hideSkeleton() {
        titleLabel.hideSkeleton()
        tableView.hideSkeleton()
        detailsButton.hideSkeleton()
    }
    
    // MARK: - Private

    private func setupUI() {
        backgroundColor = .background
        layer.cornerRadius = Size.cornerRadius
        clipsToBounds = true
        isSkeletonable = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowRadius = Size.cornerRadius / 2
        layer.masksToBounds = false

        addSubview(titleLabel)
        addSubview(tableView)
        addSubview(detailsButton)

        setupConstraints()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Spacing.small)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Spacing.smallest)
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
