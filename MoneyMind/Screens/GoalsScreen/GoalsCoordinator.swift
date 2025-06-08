//
//  GoalsCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit
import Combine

final class GoalsCoordinator: Coordinator {
    // MARK: - Properties
    
    private let navigationController: UINavigationController
    private let diContainer: AppDIContainer
    var childCoordinators: [Coordinator] = []
    
    // MARK: - Init
    
    init(
        navigationController: UINavigationController,
        diContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    // MARK: - Public Methods
    
    func start() {
        let goalsService = diContainer.resolve(GoalsServiceProtocol.self)
        let viewModel = GoalsViewModel(coordinator: self, goalsService: goalsService)
        let controller = GoalsController(viewModel: viewModel)
        controller.tabBarItem = UITabBarItem(
            title: "Цели",
            image: UIImage(named: "goals"),
            selectedImage: UIImage(named: "goals_selected")
        )
        navigationController.setViewControllers([controller], animated: false)
    }
    
    func openNewGoalScreen(_ didAddGoal: PassthroughSubject<Void, Never>) {
        let addGoalCoordinator = AddGoalCoordinator(
            navigationController: navigationController,
            diContainer: diContainer
        )
        addGoalCoordinator.start(
            mode: .create,
            didAddGoal: didAddGoal,
            goal: nil
        )
    }
    
    func openDetailGoalScreen(goal: Goal, _ didAddGoal: PassthroughSubject<Void, Never>) {
        let detailGoalScreen = DetailGoalCoordinator(
            navigationController: navigationController,
            diContainer: diContainer
        )
        detailGoalScreen.start(goal: goal, didAddGoal: didAddGoal)
    }
}
