//
//  AddTransactionCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//
import UIKit

final class AddTransactionCoordinator: Coordinator {
    // MARK: - Properties
    
    private let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Public
    
    func start() {
        let viewModel = AddTransactionViewModel(coordinator: self)
        let controller = AddTransactionController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: false)
    }
}
