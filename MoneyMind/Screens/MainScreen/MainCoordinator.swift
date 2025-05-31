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
    private let diContainer: AppDIContainer
    
    // MARK: - Init
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }

    // MARK: - Public
    
    func start() {
        let expencesService = diContainer.resolve(ExpencesServiceProtocol.self)
        let goalsManager = diContainer.resolve(GoalsManagerProtocol.self)
        let imageService = diContainer.resolve(ImageServiceProtocol.self)
        let viewModel = MainViewModel(
            expencesService: expencesService,
            goalsManager: goalsManager,
            coordinator: self,
            imageService: imageService
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
        let expencesCoordinator = ExpencesCoordinator(
            navigationController: navigationController,
            diContainer: diContainer
        )
        expencesCoordinator.start()
    }
}
