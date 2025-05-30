//
//  MainCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit
import Swinject

final class MainCoordinator: Coordinator {
    // MARK: - Properties
    
    private let navigationController: UINavigationController
    private let resolver: Resolver
    
    // MARK: - Init
    
    init(navigationController: UINavigationController, resolver: Resolver) {
        self.navigationController = navigationController
        self.resolver = resolver
    }

    // MARK: - Public
    
    func start() {
        let expencesManager = diContainer.resolve(ExpencesServiceProtocol.self)
        let goalsManager = diContainer.resolve(GoalsManagerProtocol.self)
        let viewModel = MainViewModel(
            expencesManager: expencesService,
            goalsManager: goalsManager,
            coordinator: self
        )
        let controller = MainViewController(viewModel: viewModel)
        controller.tabBarItem = UITabBarItem(
            title: "Главная",
            image: UIImage(named: "home"),
            selectedImage: UIImage(named: "home_selected")
        )
        navigationController.setViewControllers([controller], animated: false)
    }

    func openExpencesScreen() {
        let expencesCoordinator = ExpencesCoordinator(navigationController: navigationController, diContainer: diContainer)
        expencesCoordinator.start()
    }
}
