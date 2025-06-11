//
//  MainCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit
import Swinject

protocol MainCoordinatorProtocol {
    func start()
    func openExpencesScreen()
    func openGoalsScreen()
}

final class MainCoordinator: Coordinator, MainCoordinatorProtocol {
    // MARK: - Properties
    
    private let navigationController: UINavigationController
    private let diContainer: AppDIContainer
    private weak var tabBarCoordinator: TabBarCoordinator?

    // MARK: - Init
    
    init(
        navigationController: UINavigationController,
        diContainer: AppDIContainer,
        tabBarCoordinator: TabBarCoordinator
    ) {
        self.navigationController = navigationController
        self.diContainer = diContainer
        self.tabBarCoordinator = tabBarCoordinator
    }

    // MARK: - Public
    
    func start() {
        let expencesService = diContainer.resolve(ExpencesServiceProtocol.self)
        let goalsService = diContainer.resolve(GoalsServiceProtocol.self)
        let imageService = diContainer.resolve(ImageServiceProtocol.self)
        let viewModel = MainViewModel(
            expencesService: expencesService,
            goalsService: goalsService,
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
    
    func openGoalsScreen() {
        tabBarCoordinator?.switchTab(to: .goals)
    }
}
