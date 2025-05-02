//
//  TabBarCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit

final class TabBarCoordinator: NSObject, Coordinator {
    // MARK: - Properties
    
    let tabBarController: UITabBarController
    private let window: UIWindow
    var childCoordinators: [Coordinator] = []
    private var initializedCoordinators: [Int: Coordinator] = [:]
    
    // MARK: - Init
    
    init(window: UIWindow) {
        self.window = window
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let mainCoordinator = MainCoordinator(window: window)
        childCoordinators = [mainCoordinator]
        mainCoordinator.start()
        initializedCoordinators[0] = mainCoordinator
        
        let mainNavController = mainCoordinator.getNavigationController()
        let budgetNavController = UINavigationController()
        let addNavController = UINavigationController()
        let goalsNavController = UINavigationController()
        let moreNavController = UINavigationController()
        
        tabBarController.viewControllers = [
            mainNavController,
            budgetNavController,
            addNavController,
            goalsNavController,
            moreNavController
        ]
        tabBarController.viewControllers?[0].tabBarItem = UITabBarItem(
            title: "Главная",
            image: UIImage(named: "home"),
            selectedImage: UIImage(named: "home_selected")
        )
        
        tabBarController.viewControllers?[1].tabBarItem = UITabBarItem(
            title: "Бюджет",
            image: UIImage(named: "budget"),
            selectedImage: UIImage(named: "budget_selected")
        )
        
        tabBarController.viewControllers?[2].tabBarItem = UITabBarItem(
            title: "Добавить",
            image: UIImage(named: "add_transaction"),
            selectedImage: UIImage(named: "add_selected")
        )
        
        tabBarController.viewControllers?[3].tabBarItem = UITabBarItem(
            title: "Цели",
            image: UIImage(named: "goals"),
            selectedImage: UIImage(named: "goals_selected")
        )
        
        tabBarController.viewControllers?[4].tabBarItem = UITabBarItem(
            title: "Еще",
            image: UIImage(named: "more"),
            selectedImage: UIImage(named: "more_selected")
        )
        
        self.tabBarController.delegate = self
    }
}

extension TabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard
            let index = tabBarController.viewControllers?.firstIndex(of: viewController),
            initializedCoordinators[index] == nil else { return }
        
        let oldNavController = tabBarController.viewControllers?[index]
        let oldTabBarItem = oldNavController?.tabBarItem

        let navigationController = UINavigationController()
        var coordinator: Coordinator?
        
        switch index {
        case 1:
            coordinator = DistributionCoordinator(navigationController: navigationController, window: window)
            if let distributionCoordinator = coordinator as? DistributionCoordinator {
                let budget = UserManager.shared.budget
                distributionCoordinator.start(with: budget)
            }
        case 2:
            coordinator = AddTransactionCoordinator(navigationController: navigationController)
        case 3:
            coordinator = GoalsCoordinator(navigationController: navigationController)
        case 4:
            coordinator = MoreCoordinator(navigationController: navigationController)
        default:
            return
        }
        
        if let coordinator {
            childCoordinators.append(coordinator)
            initializedCoordinators[index] = coordinator
            if let oldTabBarItem = oldTabBarItem {
                navigationController.tabBarItem = oldTabBarItem
            }
            
            if !(coordinator is DistributionCoordinator) {
                coordinator.start()
            }
            
            tabBarController.viewControllers?[index] = navigationController
            tabBarController.selectedIndex = index
        }
    }
}
