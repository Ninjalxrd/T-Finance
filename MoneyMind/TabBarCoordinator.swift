//
//  TabBarCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    // MARK: - Properties
    
    var childCoordinators = [Coordinator]()
    private let window: UIWindow
    private let tabBarController: UITabBarController
    
    // MARK: - Init
    init(window: UIWindow, tabBarController: UITabBarController) {
        self.window = window
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let mainCoordinator = MainCoordinator(window: window)
        let distributionCoordinator = DistributionCoordinator(navigationController: UINavigationController())
    }
    
    
}
