//
//  TabBarCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit

enum TabIndex: Int {
    case main   = 0
    case budget = 1
    case add    = 2
    case goals  = 3
    case more   = 4
}

final class TabBarCoordinator: NSObject, Coordinator {
    // MARK: - Properties
    
    let tabBarController: UITabBarController
    let budget = UserManager.shared.budget
    private var childCoordinators: [Coordinator] = []
    private let diContainer: AppDIContainer
    private unowned let window: UIWindow
    private var addCoordinator: AddTransactionCoordinator?

    // MARK: - Init
    
    init(diContainer: AppDIContainer, window: UIWindow) {
        self.diContainer = diContainer
        self.tabBarController = UITabBarController()
        self.window = window
        super.init()
    }

    // MARK: - Public Methods
    
    func start() {
        let mainNav = UINavigationController()
        let mainCoordinator = MainCoordinator(
            navigationController: mainNav,
            diContainer: diContainer,
            tabBarCoordinator: self
        )
        addChild(mainCoordinator)

        let budgetNav = UINavigationController()
        let budgetCoordinator = DistributionCoordinator(
            navigationController: budgetNav,
            diContainer: diContainer,
            window: window
        )
        addChild(budgetCoordinator)

        let addNav = UINavigationController()
        let addCoordinator = AddTransactionCoordinator(
            navigationController: addNav,
            diContainer: diContainer,
            tabBarController: tabBarController
        )
        self.addCoordinator = addCoordinator
        addChild(addCoordinator)

        let goalsNav = UINavigationController()
        let goalsCoordinator = GoalsCoordinator(
            navigationController: goalsNav,
            diContainer: diContainer
        )
        addChild(goalsCoordinator)

        let moreNav = UINavigationController()
        let moreCoordinator = MoreCoordinator(
            navigationController: moreNav
        )
        addChild(moreCoordinator)

        mainCoordinator.start()
        budgetCoordinator.start(with: budget)
        addCoordinator.start()
        goalsCoordinator.start()
        moreCoordinator.start()

        tabBarController.delegate = self
        tabBarController.viewControllers = [mainNav, budgetNav, addNav, goalsNav, moreNav]
    }
    // MARK: - Private Methods

    private func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
}

extension TabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let index = tabBarController.viewControllers?.firstIndex(of: viewController) else { return }

        if index == TabIndex.add.rawValue {
            addCoordinator?.resetView()
        }
    }
}

extension TabBarCoordinator {
    func switchTab(to tab: TabIndex) {
        tabBarController.selectedIndex = tab.rawValue
    }
}
