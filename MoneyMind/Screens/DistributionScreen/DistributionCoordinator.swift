//
//  AddCategoryCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 18.04.2025.
//

import UIKit
import Combine

final class DistributionCoordinator: Coordinator {
    // MARK: - Properties

    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    private let diContainer: AppDIContainer
    private let transitionDelegate = CustomTransitioningDelegate()
    private var cancellables = Set<AnyCancellable>()
    private var distributionViewModel: DistributionViewModel?
    private unowned var window: UIWindow
    private var budget: Int?
    
    // MARK: - Init

    init(
        navigationController: UINavigationController,
        diContainer: AppDIContainer,
        window: UIWindow
    ) {
        self.navigationController = navigationController
        self.diContainer = diContainer
        self.window = window
    }
    
    // MARK: - Start
    
    func start(with budget: Int) {
        self.budget = budget
        start()
    }
    
    func start() {
        guard let budget else {
            assertionFailure("Budget must be set for start Distribution screen")
            return
        }
        let expenceService = diContainer.resolve(ExpencesServiceProtocol.self)
        let budgetService = diContainer.resolve(BudgetServiceProtocol.self)
        let distributionViewModel = DistributionViewModel(
            totalBudget: budget,
            coordinator: self,
            expenceService: expenceService,
            budgetService: budgetService
        )
        let distributionViewController = DistributionViewController(
            distributionViewModel: distributionViewModel)
        distributionViewController.tabBarItem = UITabBarItem(
            title: "Бюджет",
            image: UIImage(named: "budget"),
            selectedImage: UIImage(named: "budget_selected")
            )
        self.distributionViewModel = distributionViewModel
        navigationController.pushViewController(distributionViewController, animated: true)
    }
    
    // MARK: - Public Methods

    func openProcentDetailsScreen(budget: Int, selectedCategory: Category) {
        let procentCoordinator = ProcentDetailsCoordinator(
            navigationController: navigationController,
            budget: budget,
            remainingPercent: distributionViewModel?.remainingPercent ?? 0,
            selectedCategory: selectedCategory) { [weak self] categoryData in
                self?.distributionViewModel?.selectCategory(from: categoryData)
        }
        childCoordinators.append(procentCoordinator)
        procentCoordinator.start()
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Вы распределили все проценты", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        navigationController.present(alert, animated: true)
    }
    
    func showWarningAlert(confirm: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "Обратите внимание!",
            message: """
                     Вы распределили не все проценты!
                     Оставшаяся часть будет перенесена в категорию «Другое».
                     """,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Хорошо", style: .default) { _ in
            confirm()
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        navigationController.present(alert, animated: true)
    }
    
    func openMainScreen() {
        let tabBarCoordinator = TabBarCoordinator(
            diContainer: diContainer,
            window: window
        )
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
            
        window.rootViewController = tabBarCoordinator.tabBarController
        window.makeKeyAndVisible()
    }
}
