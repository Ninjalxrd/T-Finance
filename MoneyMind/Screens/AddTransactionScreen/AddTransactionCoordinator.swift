//
//  AddTransactionCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//
import UIKit
import Combine

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
        let expenceService = diContainer.resolve(ExpencesServiceProtocol.self)
        let viewModel = AddTransactionViewModel(
            coordinator: self,
            expenceService: expenceService
        )
        let controller = AddTransactionController(viewModel: viewModel)
        controller.tabBarItem = UITabBarItem(
            title: "Добавить",
            image: UIImage(named: "add_transaction"),
            selectedImage: UIImage(named: "add_selected")
        )
        navigationController.setViewControllers([controller], animated: false)
    }
    
    func openCategoriesScreen(_ categorySubject: CurrentValueSubject<TransactionCategory?, Never>) {
        let categoriesCoordinator = CategoriesCoordinator(
            navigationController: navigationController,
            diContainer: diContainer,
            categorySubject: categorySubject
        )
        categoriesCoordinator.start()
    }
    
    func presentDatePicker(dateSubject: CurrentValueSubject<Date, Never>) {
        let dateVC = DatePickerViewController(dateSubject: dateSubject)
        dateVC.modalPresentationStyle = .formSheet
        navigationController.present(dateVC, animated: true)
    }
    
    func dismissScreen() {
        navigationController.dismiss(animated: true)
    }
}
