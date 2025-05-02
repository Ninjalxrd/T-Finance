//
//  EnterNameCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 25.04.2025.
//

import UIKit

final class EnterNameCoordinator: Coordinator {
    // MARK: - Properties

    private let window: UIWindow
    private let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    // MARK: - Init
    
    init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
    }
    
    // MARK: Methods
    
    func start() {
        let viewModel = EnterNameViewModel(coordinator: self)
        let enterNameViewController = EnterNameViewController(viewModel: viewModel)
        navigationController.setViewControllers([enterNameViewController], animated: true)
    }
    
    func openBudgetInputScreen() {
        let budgetInputCoordinator = BudgetInputCoordinator(navigationController: navigationController, window: window)
        budgetInputCoordinator.start()
    }
}
