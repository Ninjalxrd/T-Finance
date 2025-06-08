//
//  GoalsController.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit
import Combine

final class GoalsController: UIViewController {
    private let viewModel: GoalsViewModel
    private let goalsView = GoalsView()
    private var bag: Set<AnyCancellable> = []
    
    init(viewModel: GoalsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = goalsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDependencies()
        setupCallbacks()
        bindViewModel()
    }
    
    private func setupCallbacks() {
        goalsView.addGoalPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.openAddGoalScreen()
            }
            .store(in: &bag)
    }
    
    private func bindViewModel() {
        viewModel.$goals
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.goalsView.reloadCollectionView()
            }
            .store(in: &bag)
    }
    
    private func setupDependencies() {
        goalsView.setCollectionViewDependencies(self, self)
    }
}

extension GoalsController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.goals.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GoalCell.identifier,
            for: indexPath)
                as? GoalCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(with: viewModel.goals[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.openDetailGoalScreen(goal: viewModel.goals[indexPath.row])
    }
}
