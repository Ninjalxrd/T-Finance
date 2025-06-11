//
//  ChartView.swift
//  MoneyMind
//
//  Created by Павел on 04.05.2025.
//

import DGCharts
import UIKit
import SnapKit
import Combine

final class ChartView: UIView {
    // MARK: – Private UI

    private let chartView = PieChartView()
    private let selectedCategoryLabel: UILabel = {
        let label = UILabel()
        label.font = Font.title.font
        label.textAlignment = .center
        label.textColor = .label
        label.text = ""
        return label
    }()

    private var categories: [Category] = []

    // MARK: – Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupDefaultChart()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: – UI Setup
    
    private func setupUI() {
        chartView.legend.enabled = false
        chartView.drawHoleEnabled = true
        chartView.holeRadiusPercent = 0.6
        chartView.holeColor = .clear
        chartView.transparentCircleRadiusPercent = 0
        chartView.usePercentValuesEnabled = true
        chartView.rotationEnabled = false
        chartView.entryLabelFont = Font.body.font
        chartView.drawEntryLabelsEnabled = false
        chartView.delegate = self

        chartView.layer.shadowColor = UIColor.black.cgColor
        chartView.layer.shadowOffset = CGSize(width: 0, height: 2)
        chartView.layer.shadowOpacity = 0.5
        chartView.layer.shadowRadius = 4
        chartView.layer.masksToBounds = false

        addSubview(chartView)
        addSubview(selectedCategoryLabel)

        chartView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        selectedCategoryLabel.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom).offset(Spacing.small)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(Spacing.smallest)
        }
    }

    // MARK: – Default state
    
    private func setupDefaultChart() {
        let entry = PieChartDataEntry(value: 1)
        let dataSet = PieChartDataSet(entries: [entry])
        dataSet.colors = [UIColor(.defaultChart)]
        dataSet.drawValuesEnabled = false
        chartView.data = PieChartData(dataSet: dataSet)
        chartView.animate(yAxisDuration: 0.7, easingOption: .easeOutBack)
        UIView.animate(withDuration: 0.2) {
            self.selectedCategoryLabel.alpha = 0
        }
    }

    // MARK: – Public
    func updateChart(with categories: [Category]) {
        guard !categories.isEmpty else { setupDefaultChart(); return }
        self.categories = categories

        let entries = categories.enumerated().map { idx, category in
            PieChartDataEntry(
                value: Double(category.percent),
                label: nil,
                data: idx as NSNumber)
        }

        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = categories.map { UIColor(hex: $0.backgroundColor) ?? .darkGray }
        dataSet.drawValuesEnabled = false

        chartView.data = PieChartData(dataSet: dataSet)
        chartView.animate(yAxisDuration: 0.4, easingOption: .easeInOutQuad)

        UIView.animate(withDuration: 0.2) {
            self.selectedCategoryLabel.alpha = 0
        }
    }
}

    // MARK: – ChartViewDelegate
extension ChartView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let idxNum = entry.data as? NSNumber else { return }
        let idx = idxNum.intValue
        guard categories.indices.contains(idx) else { return }
        let category = categories[idx]
        selectedCategoryLabel.text = category.name
        UIView.transition(with: selectedCategoryLabel, duration: 0.25, options: .transitionCrossDissolve) {
            self.selectedCategoryLabel.alpha = 1
        }
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
            self.selectedCategoryLabel.text = ""
    }
}
