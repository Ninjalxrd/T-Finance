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
    private let diContainer: AppDIContainer

    // MARK: - Init
    
    init(diContainer: AppDIContainer) {
        self.diContainer = diContainer
        self.tabBarController = UITabBarController()
        super.init()
    }

    // MARK: - Public Methods
    
    func start() {
        let mainNav = UINavigationController()
        let mainCoordinator = MainCoordinator(navigationController: mainNav, diContainer: diContainer)
        addChild(mainCoordinator)

        let budgetNav = UINavigationController()
        let budgetCoordinator = DistributionCoordinator(navigationController: budgetNav, diContainer: diContainer)
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
