//
//  BudgetInputCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 13.04.2025.
//

import UIKit

final class BudgetInputCoordinator: Coordinator {
    // MARK: - Properties
    
    private let navigationController: UINavigationController
    private let window: UIWindow
    private var distributionCoordinator: DistributionCoordinator?
    var childCoordinators: [Coordinator] = []

    // MARK: - Init
    init(window: UIWindow) {
        self.navigationController = UINavigationController()
        self.window = window
    }

    // MARK: - Public
    func start() {
        let viewModel = BudgetInputViewModel(coordinator: self)
        let controller = BudgetInputController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func openDistributionScreen(with budget: Int) {
        distributionCoordinator = DistributionCoordinator(navigationController: navigationController)
        distributionCoordinator?.start(with: budget)
    }
}
