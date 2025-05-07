//
//  EnterNameCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 25.04.2025.
//

import UIKit

final class EnterNameCoordinator: Coordinator {
    // MARK: - Properties
    
    private let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Public Methods
    
    func start() {
        let viewModel = EnterNameViewModel(coordinator: self)
        let enterNameViewController = EnterNameViewController(viewModel: viewModel)
        navigationController.setViewControllers([enterNameViewController], animated: true)
    }
    
    func openBudgetInputScreen() {
        let budgetInputCoordinator = BudgetInputCoordinator(navigationController: navigationController)
        budgetInputCoordinator.start()
    }
}
