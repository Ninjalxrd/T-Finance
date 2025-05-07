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
}
