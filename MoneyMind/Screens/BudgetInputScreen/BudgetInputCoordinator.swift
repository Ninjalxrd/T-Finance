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
    private let window: UIWindow
    private var distributionCoordinator: DistributionCoordinator?
    var childCoordinators: [Coordinator] = []

    // MARK: - Init
    
    init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
    }
    
    // MARK: - Public
    
    func start() {
        let viewModel = BudgetInputViewModel(coordinator: self)
        let controller = BudgetInputController(viewModel: viewModel)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        navigationController.setViewControllers([controller], animated: true)
    }

    func openDistributionScreen(with budget: Int) {
        distributionCoordinator = DistributionCoordinator(navigationController: navigationController, window: window)
        guard let distributionCoordinator else { return }
        childCoordinators.append(distributionCoordinator)
        distributionCoordinator.start(with: budget)
    }
}
