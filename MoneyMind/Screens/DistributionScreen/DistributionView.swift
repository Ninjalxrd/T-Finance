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
    // MARK: - Publishers
    
    private let nextScreenSubject = PassthroughSubject<Void, Never>()
    var nextScreenPublisher: AnyPublisher<Void, Never> {
        nextScreenSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    private lazy var titleLabel: UILabel = {
        let label = DefaultTitleLabel(numberOfLines: 2, text: "Распределите\nбюджет")
        return label
    }()
    
    private lazy var chartView: ChartView = {
        let chart = ChartView()
        return chart
    }()
    
    private lazy var categoriesCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collection.register(
            DistributionCollectionViewCell.self,
            forCellWithReuseIdentifier: DistributionCollectionViewCell.identifier)
        collection.backgroundColor = .background
        return collection
    }()
    
    // MARK: - CollectionView Internal Methods
    
    func setCollectionViewDelegate(_ delegate: UICollectionViewDelegate) {
        categoriesCollectionView.delegate = delegate
    }
    
    func setCollectionViewDataSource(_ dataSource: UICollectionViewDataSource) {
        categoriesCollectionView.dataSource = dataSource
    }
    
    func collectionViewReloadData() {
        categoriesCollectionView.reloadData()
    }
    
    private lazy var nextScreenButton: UIButton = {
        let button = DefaultButton(title: "Далее", action: nextScreenAction)
        return button
    }()
    
    private lazy var nextScreenAction = UIAction { [weak self] _ in
        self?.nextScreenSubject.send()
    }
    
    // MARK: - Public Methods
    func setNextScreenButtonEnabled(_ isEnabled: Bool) {
        nextScreenButton.isEnabled = isEnabled
        nextScreenButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
    func updateChart(with categories: [Category]) {
        chartView.updateChart(with: categories)
    }
    
    // MARK: - Private Methods
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .estimated(CGFloat.estimatedCellWidth),
            heightDimension: .absolute(CGFloat.cellHeight)))

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(CGFloat.cellHeight))
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
    
    // MARK: - Setup UI
    
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
            make.width.height.equalTo(CGFloat.chartSize)
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
            make.height.equalTo(CGFloat.buttonHeight)
        }
    }
}

// MARK: - Constants
private extension CGFloat {
    static let chartSize: CGFloat = 240
    static let buttonHeight: CGFloat = 56
    static let cellHeight: CGFloat = 32
    static let estimatedCellWidth: CGFloat = 150
}
