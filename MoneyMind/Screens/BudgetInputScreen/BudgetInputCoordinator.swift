
//
//  BudgetInputCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 13.04.2025.
//

import UIKit

final class BudgetInputCoordinator {
    // MARK: Properties
    var navigationController: UINavigationController
    private var distributionCoordinator: DistributionCoordinator?

    // MARK: Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: Public
    func start() {
        let viewModel = BudgetInputViewModel(coordinator: self)
        let controller = BudgetInputController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: true)
    }

    func openDistributionScreen(with budget: Int) {
        distributionCoordinator = DistributionCoordinator(navigationController: navigationController)
        distributionCoordinator?.start(with: budget)
    }
}
