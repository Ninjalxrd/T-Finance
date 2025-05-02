//
//  AddCategoryCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 18.04.2025.
//

import UIKit
import Combine

final class DistributionCoordinator: Coordinator {
    // MARK: - Properties

    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    private let transitionDelegate = CustomTransitioningDelegate()
    private let window: UIWindow
    private var cancellables = Set<AnyCancellable>()
    private var distributionViewModel: DistributionViewModel?
    private var budget: Int?
    
    // MARK: - Init

    init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
    }
    
    // MARK: - Start
    
    func start(with budget: Int) {
        self.budget = budget
        start()
    }
    
    func start() {
        guard let budget else {
            assertionFailure("Budget must be set for start Distribution screen")
            return
        }
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
        let procentCoordinator = ProcentDetailsCoordinator(
            navigationController: navigationController,
            budget: budget,
            remainingPercent: distributionViewModel?.remainingPercent ?? 0,
            selectedCategory: selectedCategory) { [weak self] categoryData in
                self?.distributionViewModel?.selectCategory(from: categoryData)
        }
        childCoordinators.append(procentCoordinator)
        procentCoordinator.start()
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Вы распределили все проценты", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        navigationController.present(alert, animated: true)
    }
    
    func openMainScreen() {
        let tabBarCoordinator = TabBarCoordinator(window: window)
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
        window.rootViewController = tabBarCoordinator.tabBarController
        window.makeKeyAndVisible()
    }
}
