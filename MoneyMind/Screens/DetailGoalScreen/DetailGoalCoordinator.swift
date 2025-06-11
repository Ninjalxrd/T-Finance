//
//  DetailGoalCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 07.06.2025.
//

import Foundation
import UIKit
import Combine

final class DetailGoalCoordinator {
    // MARK: - Properties
    
    private let navigationController: UINavigationController
    private let diContainer: AppDIContainer
    
    // MARK: - Init
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start(goal: Goal, didAddGoal: PassthroughSubject<Void, Never>) {
        let goalsService = diContainer.resolve(GoalsServiceProtocol.self)
        let detailViewModel = DetailViewModel(
            goal: goal,
            coordinator: self,
            goalsService: goalsService,
            didAddGoal: didAddGoal
        )
        let detailGoalController = DetailGoalController(detailViewModel: detailViewModel)
        navigationController.pushViewController(detailGoalController, animated: true)
    }
    
    func openEditScreen(
        didAddGoal: PassthroughSubject<Void, Never>,
        goal: Goal
    ) {
        let editGoalCoordinator = AddGoalCoordinator(
            navigationController: navigationController,
            diContainer: diContainer
        )
        editGoalCoordinator.start(
            mode: .edit,
            didAddGoal: didAddGoal,
            goal: goal
        )
    }
}
