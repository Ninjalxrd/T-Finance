//
//  DistributionView.swift
//  MoneyMind
//
//  Created by Павел on 13.04.2025.
//

import UIKit
import DGCharts
import SnapKit
import Combine

final class DistributionView: UIView {
    private let nextScreenSubject = PassthroughSubject<Void, Never>()
    var nextScreenPublisher: AnyPublisher<Void, Never> {
        nextScreenSubject.eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()
    private var entries: [PieChartDataEntry] = []
    private var dataSetColors: [NSUIColor] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupDefaultChart()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = Font.title.font
        label.textColor = .text
        label.text = "Распределите\nбюджет"
        return label
    }()
    
    private lazy var chartView: PieChartView = {
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
        return chart
    }()
    
    lazy var categoriesCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collection.register(
            DistributionCollectionViewCell.self,
            forCellWithReuseIdentifier: DistributionCollectionViewCell.identifier)
        collection.backgroundColor = .background
        return collection
    }()
    
    private lazy var nextScreenButton: UIButton = {
        let button = UIButton(primaryAction: nextScreenAction)
        button.setTitle("Далее", for: .normal)
        button.backgroundColor = .brand
        button.titleLabel?.font = Font.button.font
        button.tintColor = .text
        button.layer.cornerRadius = Size.cornerRadius
        button.clipsToBounds = true
        return button
    }()
    
    func setNextScreenButtonEnabled(_ isEnabled: Bool) {
        nextScreenButton.isEnabled = isEnabled
        nextScreenButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
    private lazy var nextScreenAction = UIAction { [weak self] _ in
        self?.nextScreenSubject.send()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .estimated(150),
            heightDimension: .absolute(32)))

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(32))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        
        group.interItemSpacing = .fixed(Spacing.small)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Spacing.small
        section.contentInsets = NSDirectionalEdgeInsets(
            top: Spacing.small,
            leading: 0,
            bottom: Spacing.small,
            trailing: 0)

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func setupDefaultChart() {
        let entry = PieChartDataEntry(value: 1)
        let dataSet = PieChartDataSet(entries: [entry])
        dataSet.colors = [UIColor(.defaultChart)]
        dataSet.drawValuesEnabled = false
        chartView.data = PieChartData(dataSet: dataSet)
        chartView.animate(yAxisDuration: 0.7, easingOption: .easeOutBack)
    }
    
    func updateChart(with categories: [Category]) {
        guard !categories.isEmpty else {
            setupDefaultChart()
            return
        }
        
        entries = categories.map { category in
            return PieChartDataEntry(value: Double(category.percent))
        }
        
        dataSetColors = categories.map { category in
            UIColor(hex: category.backgroundColor) ?? .black
        }
        
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = dataSetColors
        dataSet.drawValuesEnabled = false
        
        chartView.data = PieChartData(dataSet: dataSet)
        chartView.animate(yAxisDuration: 0.4, easingOption: .linear)
        chartView.notifyDataSetChanged()
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(chartView)
        addSubview(categoriesCollectionView)
        addSubview(nextScreenButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Spacing.small)
            make.leading.equalToSuperview().offset(Spacing.small)
            make.trailing.equalToSuperview().offset(-Spacing.small)
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Spacing.large)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(240)
        }
        
        categoriesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom).offset(Spacing.large)
            make.leading.equalToSuperview().offset(Spacing.small)
            make.trailing.equalToSuperview().offset(-Spacing.small)
            make.bottom.equalTo(nextScreenButton.snp.top).offset(-Spacing.medium)
        }
        
        nextScreenButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Spacing.medium)
            make.trailing.equalToSuperview().offset(-Spacing.medium)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-Spacing.medium)
            make.height.equalTo(56)
        }
    }
}
