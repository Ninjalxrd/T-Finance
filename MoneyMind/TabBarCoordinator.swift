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
    let budget = UserManager.shared.budget
    private var childCoordinators: [Coordinator] = []

    // MARK: - Init
    
    override init() {
        self.tabBarController = UITabBarController()
        super.init()
    }

    // MARK: - Public Methods
    
    func start() {
        let mainNav = UINavigationController()
        let mainCoordinator = MainCoordinator(navigationController: mainNav)
        addChild(mainCoordinator)

        let budgetNav = UINavigationController()
        let budgetCoordinator = DistributionCoordinator(navigationController: budgetNav)
        addChild(budgetCoordinator)

        let addNav = UINavigationController()
        let addCoordinator = AddTransactionCoordinator(navigationController: addNav)
        addChild(addCoordinator)

        let goalsNav = UINavigationController()
        let goalsCoordinator = GoalsCoordinator(navigationController: goalsNav)
        addChild(goalsCoordinator)

        let moreNav = UINavigationController()
        let moreCoordinator = MoreCoordinator(navigationController: moreNav)
        addChild(moreCoordinator)

        mainCoordinator.start()
        budgetCoordinator.start(with: budget)
        addCoordinator.start()
        goalsCoordinator.start()
        moreCoordinator.start()

        tabBarController.viewControllers = [mainNav, budgetNav, addNav, goalsNav, moreNav]
    }
    // MARK: - Private Methods

    private func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
}
