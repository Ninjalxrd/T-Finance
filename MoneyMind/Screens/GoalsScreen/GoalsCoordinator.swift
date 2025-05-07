//
//  GoalsCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit

final class GoalsCoordinator: Coordinator {
    // MARK: - Properties
    
    private let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Public Methods
    
    func start() {
        let viewModel = GoalsViewModel(coordinator: self)
        let controller = GoalsController(viewModel: viewModel)
        controller.tabBarItem = UITabBarItem(
            title: "Цели",
            image: UIImage(named: "goals"),
            selectedImage: UIImage(named: "goals_selected")
        )
        navigationController.setViewControllers([controller], animated: false)
    }
}
