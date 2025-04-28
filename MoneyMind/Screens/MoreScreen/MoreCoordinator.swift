//
//  MoreCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit

final class MoreCoordinator {
    // MARK: - Properties
    
    private let navigationController: UINavigationController
    private let window: UIWindow
    var childCoordinators = [Coordinator]()

    // MARK: - Init
    
    init(window: UIWindow) {
        self.navigationController = UINavigationController()
        self.window = window
    }

    // MARK: - Public
    
    func start() {
        let viewModel = MoreViewModel(coordinator: self)
        let controller = MoreViewController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
