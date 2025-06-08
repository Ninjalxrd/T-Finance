//
//  DetailGoalView.swift
//  MoneyMind
//
//  Created by Павел on 07.06.2025.
//

import UIKit
import Combine

class DetailGoalView: UIView {
    // MARK: - Properties
    
    private let editGoalSubject = PassthroughSubject<Void, Never>()
    var editPublisher: AnyPublisher<Void, Never> {
        editGoalSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
        
    private lazy var titleLabel: UILabel = {
        let label = DefaultLabel(numberOfLines: 1, text: "Placeholder")
        return label
    }()
    
    private lazy var infoView: UIView = {
        createBackView()
    }()
    
    private lazy var goalLabel: UILabel = {
        let label = UILabel()
        label.text = "Цель"
        label.font = Font.smallTitle.font
        label.textColor = .text
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = Font.subtitle.font
        label.textColor = .text
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var accumulatedLabel: UILabel = {
        let label = UILabel()
        label.text = "Накоплено"
        label.font = Font.smallTitle.font
        label.textColor = .text
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var accumulatedAmountLabel: UILabel = {
        let label = UILabel()
        label.font = Font.subtitle.font
        label.textColor = .text
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Срок"
        label.font = Font.smallTitle.font
        label.textColor = .text
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var deadlineLabel: UILabel = {
        let label = UILabel()
        label.font = Font.subtitle.font
        label.textColor = .text
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.progress = 0
        progress.trackTintColor = .lightGray
        progress.progressTintColor = UIColor.appBlue
        progress.heightAnchor.constraint(equalToConstant: CGFloat.progressBarHeight).isActive = true
        return progress
    }()
    
    private lazy var descriptionView: UIView = {
        createBackView()
    }()
    
    private lazy var descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.font = Font.smallTitle.font
        label.textColor = .text
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Font.subtitle.font
        label.textColor = .text
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var recomendationsView: UIView = {
        createBackView()
    }()
    
    private lazy var recomendationsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Рекомендации"
        label.font = Font.smallTitle.font
        label.textColor = .text
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var recomendationsLabel: UILabel = {
        let label = UILabel()
        label.text = "• Откладывать 30% от дохода\n• Устроиться в Т-Банк"
        label.font = Font.subtitle.font
        label.textColor = .text
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var editGoalButton: UIButton = {
        let button = DefaultButton(title: "Редактировать", action: addGoalAction)
        button.heightAnchor.constraint(equalToConstant: Size.buttonHeight).isActive = true
        return button
    }()
    
    private lazy var addGoalAction = UIAction { [weak self] _ in
        self?.editGoalSubject.send()
    }
    private func createBackView() -> UIView {
        let view = UIView()
        view.backgroundColor = .background
        setupShadows(view)
        return view
    }
    
    private func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(infoView)
        containerView.addSubview(editGoalButton)
        
        infoView.addSubview(goalLabel)
        infoView.addSubview(amountLabel)
        infoView.addSubview(accumulatedLabel)
        infoView.addSubview(accumulatedAmountLabel)
        infoView.addSubview(dateLabel)
        infoView.addSubview(deadlineLabel)
        infoView.addSubview(progressView)
        
        containerView.addSubview(descriptionView)
        descriptionView.addSubview(descriptionTitleLabel)
        descriptionView.addSubview(descriptionLabel)
        
        containerView.addSubview(recomendationsView)
        recomendationsView.addSubview(recomendationsTitleLabel)
        recomendationsView.addSubview(recomendationsLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Spacing.medium)
            make.leading.equalToSuperview().offset(Spacing.medium)
            make.trailing.equalToSuperview().offset(-Spacing.medium)
        }
        
        editGoalButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Spacing.medium)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-Spacing.medium)
        }
        
        setupInfoView()
        setupDescriptionView()
        setupRecomendationView()
    }
    
    private func setupInfoView() {
        infoView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Spacing.medium)
            make.leading.trailing.equalToSuperview().inset(Spacing.medium)
            make.height.equalTo(CGFloat.cardHeight)
        }
        
        goalLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Spacing.small)
            make.leading.equalToSuperview().offset(Spacing.small)
        }
        
        accumulatedLabel.snp.makeConstraints { make in
            make.top.equalTo(goalLabel.snp.bottom).offset(Spacing.medium)
            make.leading.width.equalTo(goalLabel)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(accumulatedLabel.snp.bottom).offset(Spacing.medium)
            make.leading.width.equalTo(goalLabel)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(goalLabel)
            make.trailing.equalToSuperview().offset(-Spacing.small)
            make.leading.equalTo(goalLabel.snp.trailing).offset(Spacing.medium)
        }
        
        accumulatedAmountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(accumulatedLabel)
            make.trailing.equalTo(amountLabel)
            make.leading.equalTo(amountLabel.snp.leading)
        }
        
        deadlineLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.trailing.equalTo(amountLabel)
            make.leading.equalTo(amountLabel.snp.leading)
        }
        
        progressView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Spacing.medium)
            make.bottom.equalToSuperview().offset(-Spacing.medium)
            make.height.equalTo(CGFloat.progressBarHeight)
        }
    }
    
    private func setupDescriptionView() {
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(Spacing.medium)
            make.leading.trailing.equalToSuperview().inset(Spacing.medium)
            make.height.equalTo(CGFloat.cardHeight)
        }
        
        descriptionTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Spacing.small)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitleLabel.snp.bottom).offset(Spacing.small)
            make.leading.trailing.equalToSuperview().inset(Spacing.small)
        }
    }
    
    private func setupRecomendationView() {
        recomendationsView.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom).offset(Spacing.medium)
            make.leading.trailing.equalToSuperview().inset(Spacing.medium)
            make.height.equalTo(CGFloat.cardHeight)
            make.bottom.equalToSuperview().offset(-Spacing.large)
        }
        
        recomendationsTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Spacing.small)
        }
        
        recomendationsLabel.snp.makeConstraints { make in
            make.top.equalTo(recomendationsTitleLabel.snp.bottom).offset(Spacing.small)
            make.leading.trailing.equalToSuperview().inset(Spacing.small)
        }
    }
    
    private func setupShadows(_ view: UIView) {
        view.layer.cornerRadius = Size.cornerRadius
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowRadius = Size.cornerRadius / 2
        view.layer.masksToBounds = false
    }
    
    func configureProgressBar(current: Double, total: Double) {
        let progress = total == 0 ? 0 : Float(current / total)
        progressView.progress = progress
    }
    
    func configureView(with goal: Goal) {
        titleLabel.text = goal.name
        amountLabel.text = "\(Int(goal.amount)) ₽"
        accumulatedAmountLabel.text = "\(Int(goal.accumulatedAmount)) ₽"
        deadlineLabel.text = goal.term
        descriptionLabel.text = "• \(goal.description)"
    }
}

private extension CGFloat {
    static let progressBarHeight: CGFloat = 8
    static let cardHeight: CGFloat = 180
}
