//
//  ChartView.swift
//  MoneyMind
//
//  Created by Павел on 04.05.2025.
//

import DGCharts
import UIKit
import SnapKit

final class ChartView: UIView {
    private var chartView = PieChartView()
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupDefaultChart()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI

    private func setupUI() {
        let chart = PieChartView()
        chart.legend.enabled = false
        chart.drawHoleEnabled = true
        chart.holeRadiusPercent = 0.6
        chart.holeColor = .clear
        chart.transparentCircleRadiusPercent = 0
        chart.usePercentValuesEnabled = true
        
        chart.layer.shadowColor = UIColor.black.cgColor
        chart.layer.shadowOffset = CGSize(width: 0, height: 2)
        chart.layer.shadowOpacity = 0.5
        chart.layer.shadowRadius = 4
        chart.layer.masksToBounds = false
        
        chartView = chart
        addSubview(chartView)
        
        chartView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupDefaultChart() {
        let entry = PieChartDataEntry(value: 1)
        let dataSet = PieChartDataSet(entries: [entry])
        dataSet.colors = [UIColor(.defaultChart)]
        dataSet.drawValuesEnabled = false
        chartView.animate(yAxisDuration: 0.7, easingOption: .easeOutBack)
        chartView.data = PieChartData(dataSet: dataSet)
    }
    
    func updateChart(with categories: [Category]) {
        guard !categories.isEmpty else {
            setupDefaultChart()
            return
        }
        
        let entries = categories.map { category in
            return PieChartDataEntry(value: Double(category.percent))
        }
        
        let dataSetColors = categories.map { category in
            UIColor(hex: category.backgroundColor) ?? .black
        }
        
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = dataSetColors
        dataSet.drawValuesEnabled = false
        
        chartView.data = PieChartData(dataSet: dataSet)
        chartView.animate(yAxisDuration: 0.4, easingOption: .linear)
        chartView.notifyDataSetChanged()
    }
}
