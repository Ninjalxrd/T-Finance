//
//  AppCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 22.04.2025.
//
import UIKit

protocol Coordinator: AnyObject {
    func start()
    var childCoordinators: [Coordinator] { get set }
}

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let windowScene: UIWindowScene
    var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow, windowScene: UIWindowScene) {
        self.window = window
        self.windowScene = windowScene
    }
    
    func start() {
        window.windowScene = windowScene
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
        let enterNumberCoordinator = EnterNumberCoordinator(window: window)
        childCoordinators.append(enterNumberCoordinator)
        window.rootViewController = enterNumberCoordinator.navigationController
        enterNumberCoordinator.start()
    }
    
    private func startBudgetInputFlow() {
        let budgetInputCoordinator = BudgetInputCoordinator(
            navigationController: UINavigationController(), window: window)
        childCoordinators.append(budgetInputCoordinator)
        window.rootViewController = budgetInputCoordinator.navigationController
        budgetInputCoordinator.start()
    }
    
    private func startMainFlow() {
        let tabBarCoordinator = TabBarCoordinator(window: window)
        childCoordinators.append(tabBarCoordinator)
        window.rootViewController = tabBarCoordinator.tabBarController
        tabBarCoordinator.start()
    }
}

extension Coordinator {
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
