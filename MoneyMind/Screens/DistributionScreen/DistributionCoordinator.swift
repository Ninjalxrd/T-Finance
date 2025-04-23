//
//  AddCategoryCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 18.04.2025.
//

import UIKit
import Combine

// MARK: - Protocols

protocol DistributionCoordinatorProtocol: AnyObject {
    func openProcentDetailsScreen(budget: Int, selectedCategory: Category)
}

final class DistributionCoordinator: DistributionCoordinatorProtocol {
    // MARK: - Properties

    let navigationController: UINavigationController
    private let transitionDelegate = CustomTransitioningDelegate()
    private var cancellables = Set<AnyCancellable>()
    private var distributionViewModel: DistributionViewModel?

    // MARK: - Init

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(with budget: Int) {
        let distributionViewModel = DistributionViewModel(
            totalBudget: budget,
            coordinator: self)
        let distributionViewController = DistributionViewController(
            distributionViewModel: distributionViewModel)
        self.distributionViewModel = distributionViewModel
        navigationController.pushViewController(distributionViewController, animated: true)
    }
    
    // MARK: - Public Methods

    func openProcentDetailsScreen(budget: Int, selectedCategory: Category) {
        let procentDetailsController = ProcentDetailsController(
            budget: budget,
            remainingPercent: distributionViewModel?.remainingPercent ?? 0,
            selectedCategory: selectedCategory
        )
        procentDetailsController.onAddCategory
            .sink { [weak self] categoryData in
                self?.distributionViewModel?.selectCategory(from: categoryData)
            }
            .store(in: &cancellables)
        
        procentDetailsController.modalPresentationStyle = .custom
        procentDetailsController.transitioningDelegate = transitionDelegate
        procentDetailsController.isModalInPresentation = true
        
        navigationController.present(procentDetailsController, animated: true)
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Вы распределили все проценты", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        navigationController.present(alert, animated: true)
    }
}
