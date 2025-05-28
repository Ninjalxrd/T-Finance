//
//  ExpencesView.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit
import SnapKit

final class ExpencesView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = DefaultLabel(numberOfLines: 1, text: "Расходы")
        return label
    }()
    
    private lazy var dateSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["День", "Неделя", "Месяц", "Год"])
        
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            make.height.equalTo(200)
        }
        
        expencesTableView.snp.makeConstraints { make in
            make.top.equalTo(expensesChartView.snp.bottom).offset(Spacing.medium)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupExpenceTableView() {
        expencesTableView.delegate = self
        expencesTableView.dataSource = self
    }
    
    func reloadExpencesTableView() {
        expencesTableView.reloadData()
    }
    
    func updateTotalExpenses(amount: Int) {
        totalExpensesLabel.text = "\(amount) ₽"
    }
    
    func updateExpensesChart(with categories: [Category]) {
        expensesChartView.updateChart(with: categories)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ExpencesView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ExpenceCell.identifier,
            for: indexPath) as? ExpenceCell else {
            return UITableViewCell()
        }
//        cell.configure(with: )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
