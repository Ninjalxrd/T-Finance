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
    private let diContainer: AppDIContainer
    var childCoordinators: [Coordinator] = []

    // MARK: - Init
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }

    // MARK: - Public Methods
    
    func start() {
        let viewModel = AddTransactionViewModel(coordinator: self)
        let controller = AddTransactionController(viewModel: viewModel)
        controller.tabBarItem = UITabBarItem(
            title: "Добавить",
            image: UIImage(named: "add_transaction"),
            selectedImage: UIImage(named: "add_selected")
        )
        navigationController.setViewControllers([controller], animated: false)
    }
    
    func openCategoriesScreen() {
        let categoriesCoordinator = CategoriesCoordinator(
            navigationController: navigationController,
            diContainer: diContainer
        )
        categoriesCoordinator.start()
    }
}
