//
//  MainCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit

final class MainCoordinator: Coordinator {
    // MARK: - Properties
    
    private let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Public
    
    func start() {
        let container = SwinjectManager()
        let controller = container.resolveMainController(navigationController: navigationController)
        controller.tabBarItem = UITabBarItem(
            title: "Главная",
            image: UIImage(named: "home"),
            selectedImage: UIImage(named: "home_selected")
        )
        navigationController.setViewControllers([controller], animated: false)
    }
}
