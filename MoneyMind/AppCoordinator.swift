//
//  AppCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 22.04.2025.
//
import UIKit

final class AppCoordinator {
    var window: UIWindow?
    
    func start(_ scene: UIWindowScene) {
        let window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController()
        let budgetInputCoordinator = BudgetInputCoordinator(navigationController: navigationController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        budgetInputCoordinator.start()
    }
}
