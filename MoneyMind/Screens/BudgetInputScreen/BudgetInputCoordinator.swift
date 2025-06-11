//
//  BudgetInputCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 13.04.2025.
//

import UIKit

final class BudgetInputCoordinator: Coordinator {
    // MARK: - Properties
    
    let navigationController: UINavigationController
    private var distributionCoordinator: DistributionCoordinator?
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
        let budgetService = diContainer.resolve(BudgetServiceProtocol.self)
        let viewModel = BudgetInputViewModel(coordinator: self, budgetService: budgetService)
        let controller = BudgetInputController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: true)
    }
    
    func openDistributionScreen(with budget: Int) {
        distributionCoordinator = DistributionCoordinator(
            navigationController: navigationController,
            diContainer: diContainer,
            window: window
        )
        guard let distributionCoordinator else { return }
        childCoordinators.append(distributionCoordinator)
        distributionCoordinator.start(with: budget)
    }
}
