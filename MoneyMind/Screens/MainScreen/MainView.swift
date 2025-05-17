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
    
    // MARK: - Update Values
    
    func updateChartView(with categories: [Category]) {
        budgetChartView.updateChart(with: categories)
    }
    
    func setupBudget(with budget: Int) {
        availableBudgetLabel.text = "\(budget) ₽"
    }
    
    func setupTableViewDataSource(_ dataSource: UITableViewDataSource) {
        expensesTableView.dataSource = dataSource
    }
    
    func setupTableViewDelegate(_ delegate: UITableViewDelegate) {
        expensesTableView.delegate = delegate
    }
    
    func reloadTableView() {
        expensesTableView.reloadData()
    }
    
    func showSkeletonAnimations() {
        budgetChartView.showAnimatedGradientSkeleton()
        expensesTitleLabel.showAnimatedGradientSkeleton()
        expensesDetailsButton.showAnimatedGradientSkeleton()
        expensesTableView.showAnimatedGradientSkeleton()
    }
    
    func hideSkeletonAnimations() {
        budgetChartView.hideSkeleton()
        expensesTitleLabel.hideSkeleton()
        expensesTableView.hideSkeleton()
        expensesDetailsButton.hideSkeleton()
    }
        
    // MARK: - Setup UI
    
    private func setupUI() {
        addSubview(topStackView)
        addSubview(expensesView)
        
        expensesView.addSubview(expensesTitleLabel)
        expensesView.addSubview(expensesTableView)
        expensesView.addSubview(expensesDetailsButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        topStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(Spacing.medium)
            make.trailing.equalToSuperview().offset(-Spacing.medium)
        }
        
        expensesView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(Spacing.medium)
            make.leading.trailing.equalTo(topStackView)
            make.height.equalTo(304)
        }
        setupExpencesView()
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
}

private extension CGFloat {
    static let buttonHeight: CGFloat = 56
    static let availableLabel: CGFloat = 16
    static let expenceTitleLabel: CGFloat = 48
    static let availableBudgetLabel: CGFloat = 48
    static let skeletonCornerRadius: Float = 8
}
