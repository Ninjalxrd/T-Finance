//
//  MainView.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit
import Combine
import SkeletonView

final class MainView: UIView {
    // MARK: - Publishers
    
    private let expensesScreenSubject = PassthroughSubject<Void, Never>()
    var expensesScreenPublisher: AnyPublisher<Void, Never> {
        expensesScreenSubject.eraseToAnyPublisher()
    }
    
    private let goalsScreenSubject = PassthroughSubject<Void, Never>()
    var goalsScreenPublisher: AnyPublisher<Void, Never> {
        goalsScreenSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private UI Elements
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.isSkeletonable = true
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.isSkeletonable = true
        return view
    }()
    
    private lazy var availableLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryText
        label.font = Font.subtitle.font
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "Доступно"
        label.heightAnchor.constraint(equalToConstant: CGFloat.availableLabel).isActive = true
        label.skeletonCornerRadius = CGFloat.skeletonCornerRadius
        return label
    }()
    
    private lazy var availableBudgetLabel: UILabel = {
        let label = DefaultLabel(numberOfLines: 1, text: "")
        label.isSkeletonable = true
        label.skeletonCornerRadius = CGFloat.skeletonCornerRadius
        label.heightAnchor.constraint(equalToConstant: CGFloat.availableBudgetLabel).isActive = true
        return label
    }()
    
    private lazy var availableStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [availableLabel, availableBudgetLabel])
        stack.axis = .vertical
        stack.spacing = Spacing.small
        stack.alignment = .leading
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var budgetChartView: ChartView = {
        let chart = ChartView()
        chart.isSkeletonable = true
        return chart
    }()
    
    private lazy var spacer: UIView = {
        let space = UIView()
        space.setContentHuggingPriority(.defaultLow, for: .horizontal)
        space.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return space
    }()
    
    private lazy var topStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [availableStack, spacer, budgetChartView])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    // MARK: - Expences View
    
    private lazy var expensesView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = Size.cornerRadius
        view.clipsToBounds = true

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowRadius = Size.cornerRadius / 2
        view.layer.masksToBounds = false
        return view
    }()
    
    private lazy var expensesTitleLabel: UILabel = {
        let label = DefaultLabel(numberOfLines: 1, text: "Последние")
        label.font = Font.smallViewTitle.font
        label.skeletonCornerRadius = CGFloat.skeletonCornerRadius
        label.heightAnchor.constraint(equalToConstant: CGFloat.expenceTitleLabel).isActive = true
        return label
    }()
    
    private lazy var expensesTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .clear
        tableView.isSkeletonable = true
        tableView.skeletonCornerRadius = CGFloat.skeletonCornerRadius
        tableView.register(ExpencesTableViewCell.self, forCellReuseIdentifier: ExpencesTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var expensesDetailsButton: UIButton = {
        let button = DefaultButton(title: "Подробнее", action: expensesButtonAction)
        button.isSkeletonable = true
        button.heightAnchor.constraint(equalToConstant: CGFloat.buttonHeight).isActive = true
        return button
    }()
    
    private lazy var expensesButtonAction = UIAction { [weak self] _ in
        self?.expensesScreenSubject.send()
    }
    
    // MARK: - Goals View
    
    private lazy var goalsView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = Size.cornerRadius
        view.clipsToBounds = true

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowRadius = Size.cornerRadius / 2
        view.layer.masksToBounds = false
        return view
    }()
    
    private lazy var goalsTitleLabel: UILabel = {
        let label = DefaultLabel(numberOfLines: 1, text: "Цели")
        label.font = Font.smallViewTitle.font
        label.skeletonCornerRadius = CGFloat.skeletonCornerRadius
        label.heightAnchor.constraint(equalToConstant: CGFloat.expenceTitleLabel).isActive = true
        return label
    }()
    
    private lazy var goalsTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .clear
        tableView.isSkeletonable = true
        tableView.skeletonCornerRadius = CGFloat.skeletonCornerRadius
        tableView.register(GoalsTableViewCell.self, forCellReuseIdentifier: GoalsTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var goalsDetailsButton: UIButton = {
        let button = DefaultButton(title: "Подробнее", action: goalsButtonAction)
        button.isSkeletonable = true
        button.heightAnchor.constraint(equalToConstant: CGFloat.buttonHeight).isActive = true
        return button
    }()
    
    private lazy var goalsButtonAction = UIAction { [weak self] _ in
        self?.goalsScreenSubject.send()
    }
    
    // MARK: - Update Values
    
    func updateChartView(with categories: [Category]) {
        budgetChartView.updateChart(with: categories)
    }
    
    func setupBudget(with budget: Int) {
        availableBudgetLabel.text = "\(budget) ₽"
    }
    
    func setupTableViewDataSource(_ dataSource: UITableViewDataSource) {
        expensesTableView.dataSource = dataSource
        goalsTableView.dataSource = dataSource
    }
    
    func setupTableViewDelegate(_ delegate: UITableViewDelegate) {
        expensesTableView.delegate = delegate
        goalsTableView.delegate = delegate
    }
    
    func reloadExpencesTableView() {
        expensesTableView.reloadData()
    }
    
    func reloadGoalsTableView() {
        goalsTableView.reloadData()
    }
    
    func showExpencesSkeletonAnimations() {
        availableLabel.showAnimatedGradientSkeleton()
        availableBudgetLabel.showAnimatedGradientSkeleton()
        budgetChartView.showAnimatedGradientSkeleton()
        expensesTitleLabel.showAnimatedGradientSkeleton()
        expensesDetailsButton.showAnimatedGradientSkeleton()
        expensesTableView.showAnimatedGradientSkeleton()
    }
    
    func hideExpencesSkeletonAnimations() {
        availableLabel.hideSkeleton()
        availableBudgetLabel.hideSkeleton()
        budgetChartView.hideSkeleton()
        expensesTitleLabel.hideSkeleton()
        expensesTableView.hideSkeleton()
        expensesDetailsButton.hideSkeleton()
    }
    
    func showGoalsSkeletonAnimations() {
        goalsTableView.showAnimatedGradientSkeleton()
        goalsTitleLabel.showAnimatedGradientSkeleton()
        goalsDetailsButton.showAnimatedGradientSkeleton()
    }
    
    func hideGoalsSkeletonAnimations() {
        goalsTableView.hideSkeleton()
        goalsTitleLabel.hideSkeleton()
        goalsDetailsButton.hideSkeleton()
    }
    
    // MARK: - Getters
    
    func getGoalsTableView() -> UITableView {
        return goalsTableView
    }
    
    func getExpencesTableView() -> UITableView {
        return expensesTableView
    }
        
    // MARK: - Setup UI
    
    private func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(topStackView)
        contentView.addSubview(expensesView)
        contentView.addSubview(goalsView)
        
        expensesView.addSubview(expensesTitleLabel)
        expensesView.addSubview(expensesTableView)
        expensesView.addSubview(expensesDetailsButton)
        
        goalsView.addSubview(goalsTitleLabel)
        goalsView.addSubview(goalsTableView)
        goalsView.addSubview(goalsDetailsButton)

        setupConstraints()
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        topStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(Spacing.medium)
            make.trailing.equalToSuperview().offset(-Spacing.medium)
        }

        expensesView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(Spacing.medium)
            make.leading.trailing.equalTo(topStackView)
            make.height.equalTo(CGFloat.viewHeight)
        }

        goalsView.snp.makeConstraints { make in
            make.top.equalTo(expensesView.snp.bottom).offset(Spacing.medium)
            make.leading.trailing.equalTo(expensesView)
            make.height.equalTo(CGFloat.viewHeight)
            make.bottom.equalToSuperview().offset(-Spacing.large)
        }

        setupExpencesView()
        setupGoalsView()
    }

    private func setupExpencesView() {
        expensesTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Spacing.small)
        }
        
        expensesTableView.snp.makeConstraints { make in
            make.top.equalTo(expensesTitleLabel.snp.bottom).offset(Spacing.smallest)
            make.leading.equalToSuperview().offset(Spacing.small)
            make.trailing.equalToSuperview().offset(-Spacing.small)
            make.bottom.equalTo(expensesDetailsButton.snp.top).offset(-Spacing.smallest)
        }
        
        expensesDetailsButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Spacing.small)
            make.bottom.trailing.equalToSuperview().offset(-Spacing.small)
        }
    }
    
    private func setupGoalsView() {
        goalsTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Spacing.small)
        }
        
        goalsTableView.snp.makeConstraints { make in
            make.top.equalTo(goalsTitleLabel.snp.bottom).offset(Spacing.smallest)
            make.leading.equalToSuperview().offset(Spacing.small)
            make.trailing.equalToSuperview().offset(-Spacing.small)
            make.bottom.equalTo(goalsDetailsButton.snp.top).offset(-Spacing.smallest)
        }
        
        goalsDetailsButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Spacing.small)
            make.bottom.trailing.equalToSuperview().offset(-Spacing.small)
        }
    }
}

private extension CGFloat {
    static let buttonHeight: CGFloat = 56
    static let availableLabel: CGFloat = 16
    static let expenceTitleLabel: CGFloat = 48
    static let availableBudgetLabel: CGFloat = 48
    static let skeletonCornerRadius: Float = 8
    static let viewHeight: CGFloat = 304
    static let topOffset: CGFloat = Spacing.large * 2
}
