//
//  GoalsView.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit
import Combine

final class GoalsView: UIView {
    // MARK: - Properties
    
    private let addGoalSubject = PassthroughSubject<Void, Never>()
    var addGoalPublisher: AnyPublisher<Void, Never> {
        addGoalSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = DefaultTitleLabel(numberOfLines: 1, text: "Цели")
        label.heightAnchor.constraint(equalToConstant: CGFloat.labelHeight).isActive = true
        return label
    }()
    
    private lazy var goalsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Spacing.small
        layout.itemSize = CGSize(
            width: UIScreen.main.bounds.width - 2 * Spacing.medium,
            height: CGFloat.cellHeight
        )
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GoalCell.self, forCellWithReuseIdentifier: GoalCell.identifier)
        collectionView.layer.cornerRadius = Size.cornerRadius
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .background
        return collectionView
    }()
    
    private lazy var addGoalButton: UIButton = {
        let button = DefaultButton(title: "Добавить", action: addGoalAction)
        button.heightAnchor.constraint(equalToConstant: Size.buttonHeight).isActive = true
        return button
    }()
    
    private lazy var addGoalAction = UIAction { [weak self] _ in
        self?.addGoalSubject.send()
    }
    
    // MARK: - Public Methods
    
    func setCollectionViewDependencies(
        _ dataSource: UICollectionViewDataSource,
        _ delegate: UICollectionViewDelegate
    ) {
        goalsCollectionView.delegate = delegate
        goalsCollectionView.dataSource = dataSource
    }
    
    func reloadCollectionView() {
        goalsCollectionView.reloadData()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(goalsCollectionView)
        addSubview(addGoalButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(Spacing.medium)
        }
        
        goalsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Spacing.medium)
            make.left.trailing.equalToSuperview().inset(Spacing.medium)
            make.bottom.equalTo(addGoalButton.snp.top).offset(-Spacing.medium)
        }
        
        addGoalButton.snp.makeConstraints { make in
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-Spacing.medium)
            make.leading.trailing.equalToSuperview().inset(Spacing.medium)
        }
    }
}

private extension CGFloat {
    static let labelHeight: CGFloat = 56
    static let cellHeight: CGFloat = 150
}
