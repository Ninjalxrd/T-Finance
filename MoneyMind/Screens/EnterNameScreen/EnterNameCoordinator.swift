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
    private let diContainer: AppDIContainer
    private unowned let window: UIWindow
    var childCoordinators: [Coordinator] = []
    // MARK: - Init
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer, window: UIWindow) {
        self.navigationController = navigationController
        self.diContainer = diContainer
        self.window = window
    }
    
    // MARK: - Public Methods
    
    func start() {
        let viewModel = EnterNameViewModel(coordinator: self)
        let enterNameViewController = EnterNameViewController(viewModel: viewModel)
        navigationController.setViewControllers([enterNameViewController], animated: true)
    }
    
    func openBudgetInputScreen() {
        let budgetInputCoordinator = BudgetInputCoordinator(
            navigationController: navigationController,
            diContainer: diContainer,
            window: window
        )
        budgetInputCoordinator.start()
    }
}
