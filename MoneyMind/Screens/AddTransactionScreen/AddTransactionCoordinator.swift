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
    private let window: UIWindow
    var childCoordinators: [Coordinator] = []

    // MARK: - Init
    init(window: UIWindow) {
        self.navigationController = UINavigationController()
        self.window = window
    }

    // MARK: - Public
    func start() {
        let viewModel = AddTransactionViewModel(coordinator: self)
        let controller = AddTransactionController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
