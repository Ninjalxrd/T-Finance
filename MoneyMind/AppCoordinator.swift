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
    private unowned let window: UIWindow
    private let diContainer: AppDIContainer
    var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow, diContainer: AppDIContainer) {
        self.window = window
        self.diContainer = diContainer
    }
    
    func start() {
        window.makeKeyAndVisible()
        let userManager = UserManager.shared
        if !userManager.isRegistered {
            startAuthFlow()
        } else if !userManager.hasIncome {
            startDistributionFlow()
        } else {
            startMainFlow()
        }
    }

    private func startAuthFlow() {
        let enterNumberCoordinator = EnterNumberCoordinator(
            navigationController: UINavigationController(),
            diContainer: diContainer,
            window: window
        )
        childCoordinators.append(enterNumberCoordinator)
        window.rootViewController = enterNumberCoordinator.navigationController
        enterNumberCoordinator.start()
    }
    
    private func startDistributionFlow() {
        let distributionCoordinator = DistributionCoordinator(
            navigationController: UINavigationController(),
            diContainer: diContainer,
            window: window)
        childCoordinators.append(distributionCoordinator)
        window.rootViewController = distributionCoordinator.navigationController
        distributionCoordinator.start()
    }
    
    private func startMainFlow() {
        let tabBarCoordinator = TabBarCoordinator(diContainer: diContainer, window: window)
        childCoordinators.append(tabBarCoordinator)
        window.rootViewController = tabBarCoordinator.tabBarController
        tabBarCoordinator.start()
    }
}
