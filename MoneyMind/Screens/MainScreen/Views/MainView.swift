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
    
    private let expencesView = MainExpenсesView()
    
    // MARK: - Goals View
    
    private let goalsView = MainGoalsView()

    // MARK: - Update Values
    
    func updateChartView(with categories: [Category]) {
        budgetChartView.updateChart(with: categories)
    }
    
    func setupBudget(with budget: Int) {
        availableBudgetLabel.text = "\(budget) ₽"
    }
    
    func setupTableViewDataSource(_ dataSource: UITableViewDataSource) {
        expencesView.tableView.dataSource = dataSource
        goalsView.tableView.dataSource = dataSource
    }
    
    func setupTableViewDelegate(_ delegate: UITableViewDelegate) {
        expencesView.tableView.delegate = delegate
        goalsView.tableView.delegate = delegate
    }
    
    func reloadExpencesTableView() {
        expencesView.tableView.reloadData()
    }
    
    func reloadGoalsTableView() {
        goalsView.tableView.reloadData()
    }
    
    func showExpencesSkeletonAnimations() {
        budgetChartView.showAnimatedGradientSkeleton()
        expencesView.showSkeleton()
    }
    
    func hideExpencesSkeletonAnimations() {
        budgetChartView.hideSkeleton()
        expencesView.hideSkeleton()
    }
    
    func showGoalsSkeletonAnimations() {
        goalsView.showSkeleton()
    }
    
    func hideGoalsSkeletonAnimations() {
        goalsView.hideSkeleton()
    }
    
    // MARK: - Getters
    
    func getGoalsTableView() -> UITableView {
        return goalsView.tableView
    }
    
    func getExpencesTableView() -> UITableView {
        return expencesView.tableView
    }
        
    // MARK: - Setup UI
    
    private func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(topStackView)
        contentView.addSubview(expencesView)
        contentView.addSubview(goalsView)

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

        expencesView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(Spacing.medium)
            make.leading.trailing.equalTo(topStackView)
            make.height.equalTo(CGFloat.viewHeight)
        }

        goalsView.snp.makeConstraints { make in
            make.top.equalTo(expencesView.snp.bottom).offset(Spacing.medium)
            make.leading.trailing.equalTo(expencesView)
            make.height.equalTo(CGFloat.viewHeight)
            make.bottom.equalToSuperview().offset(-Spacing.large)
        }
    }
}

private extension CGFloat {
    static let buttonHeight: CGFloat = 56
    static let availableLabel: CGFloat = 16
    static let availableBudgetLabel: CGFloat = 48
    static let skeletonCornerRadius: Float = 8
    static let viewHeight: CGFloat = 304
    static let topOffset: CGFloat = Spacing.large * 2
}
