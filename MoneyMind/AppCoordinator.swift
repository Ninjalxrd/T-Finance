//
//  AppCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 22.04.2025.
//
import UIKit

protocol Coordinator: AnyObject {
    func start()
}

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.makeKeyAndVisible()
        let userManager = UserManager.shared
        if !userManager.isRegistered {
            startAuthFlow()
        } else if !userManager.hasIncome {
            startBudgetInputFlow()
        } else {
            startMainFlow()
        }
    }

    private func startAuthFlow() {
        let enterNumberCoordinator = EnterNumberCoordinator(navigationController: UINavigationController())
        childCoordinators.append(enterNumberCoordinator)
        window.rootViewController = enterNumberCoordinator.navigationController
        enterNumberCoordinator.start()
    }
    
    private func startBudgetInputFlow() {
        let budgetInputCoordinator = BudgetInputCoordinator(
            navigationController: UINavigationController())
        childCoordinators.append(budgetInputCoordinator)
        window.rootViewController = budgetInputCoordinator.navigationController
        budgetInputCoordinator.start()
    }
    
    private func startMainFlow() {
        let tabBarCoordinator = TabBarCoordinator()
        childCoordinators.append(tabBarCoordinator)
        window.rootViewController = tabBarCoordinator.tabBarController
        tabBarCoordinator.start()
    }
}
