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
    var childCoordinators: [Coordinator] = []
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Public Methods
    
    func start() {
        let viewModel = BudgetInputViewModel(coordinator: self)
        let controller = BudgetInputController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: true)
    }
    
    func openDistributionScreen(with budget: Int) {
        distributionCoordinator = DistributionCoordinator(navigationController: navigationController)
        guard let distributionCoordinator else { return }
        childCoordinators.append(distributionCoordinator)
        distributionCoordinator.start(with: budget)
    }
}
