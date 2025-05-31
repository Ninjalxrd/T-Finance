//
//  ExpencesView.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit
import SnapKit
import Combine

final class ExpencesView: UIView {
    // MARK: - Publishers
    
    private let refreshSubject = PassthroughSubject<Void, Never>()
    var refreshPublisher: AnyPublisher<Void, Never> {
        refreshSubject.eraseToAnyPublisher()
    }
    private let periodSubject = PassthroughSubject<TimePeriod, Never>()
    var periodPublisher: AnyPublisher<TimePeriod, Never> {
        periodSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupRefreshControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = DefaultLabel(numberOfLines: 1, text: "Расходы")
        return label
    }()
    
    private lazy var dateSegmentControl: UISegmentedControl = {
        let titles = TimePeriod.allCases.map { $0.title }
        let segmentControl = UISegmentedControl(items: titles)
        segmentControl.selectedSegmentIndex = TimePeriod.month.rawValue
        segmentControl.addAction(segmentChangedAction, for: .valueChanged)
        return segmentControl
    }()
    
    private lazy var totalExpensesLabel: UILabel = {
        let label = DefaultLabel(numberOfLines: 1, text: "")
        label.font = Font.title.font
        label.textAlignment = .center
        return label
    }()
    
    private lazy var expensesChartView: ChartView = {
        let chart = ChartView()
        return chart
    }()
    
    private lazy var expencesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ExpenceCell.self, forCellReuseIdentifier: ExpenceCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 70
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        return refresh
    }()
    
    private lazy var refreshAction = UIAction { [weak self] _ in
        self?.refreshSubject.send()
    }

    private lazy var segmentChangedAction = UIAction { [weak self] _ in
        guard
            let self,
            let selectedIndex = self.dateSegmentControl.selectedSegmentIndex as Int?,
            let selectedPeriod = TimePeriod(rawValue: selectedIndex)
        else { return }
              
        self.periodSubject.send(selectedPeriod)
    }
    
    // MARK: - Private Methods
    
    private func setupRefreshControl() {
        refreshControl.addAction(refreshAction, for: .valueChanged)
        expencesTableView.refreshControl = refreshControl
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(dateSegmentControl)
        addSubview(totalExpensesLabel)
        addSubview(expensesChartView)
        addSubview(expencesTableView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Spacing.medium)
            make.leading.equalToSuperview().offset(Spacing.medium)
            make.trailing.equalToSuperview().offset(-Spacing.medium)
        }
        
        dateSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Spacing.medium)
            make.leading.equalToSuperview().offset(Spacing.medium)
            make.trailing.equalToSuperview().offset(-Spacing.medium)
        }
        
        totalExpensesLabel.snp.makeConstraints { make in
            make.top.equalTo(dateSegmentControl.snp.bottom).offset(Spacing.medium)
            make.leading.trailing.equalToSuperview().inset(Spacing.medium)
        }
        
        expensesChartView.snp.makeConstraints { make in
            make.top.equalTo(totalExpensesLabel.snp.bottom).offset(Spacing.medium)
            make.leading.trailing.equalToSuperview().inset(Spacing.medium)
            make.height.equalTo(CGFloat.chartViewHeight)
        }
        
        expencesTableView.snp.makeConstraints { make in
            make.top.equalTo(expensesChartView.snp.bottom).offset(Spacing.medium)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: - Public Methods
    
    func setupExpenceTableView(_ dataSource: UITableViewDataSource, _ delegate: UITableViewDelegate) {
        expencesTableView.delegate = delegate
        expencesTableView.dataSource = dataSource
    }
    
    func reloadExpencesTableView() {
        expencesTableView.reloadData()
    }
    
    func updateTotalExpenses(amount: Double) {
        totalExpensesLabel.text = "\(Int(amount.rounded())) ₽"
    }
    
    func updateExpensesChart(with categories: [Category]) {
        expensesChartView.updateChart(with: categories)
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}

private extension CGFloat {
    static let chartViewHeight: CGFloat = 200
}
