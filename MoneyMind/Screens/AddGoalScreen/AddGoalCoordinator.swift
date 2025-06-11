//
//  AddGoalCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 06.06.2025.
//

import UIKit
import Combine

protocol AddGoalCoordinatorProtocol {
    func presentDatePicker(dateSubject: CurrentValueSubject<Date, Never>)
    func dismissScreen()
    func goToGoalsScreen()
}

final class AddGoalCoordinator: AddGoalCoordinatorProtocol {
    private let navigationController: UINavigationController
    private let diContainer: AppDIContainer
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start(
        mode: GoalViewMode,
        didAddGoal: PassthroughSubject<Void, Never>,
        goal: Goal?
    ) {
        let goalsService = diContainer.resolve(GoalsServiceProtocol.self)
        let viewModel = AddGoalViewModel(
            coordinator: self,
            goalsService: goalsService,
            goalSubject: didAddGoal,
            mode: mode,
            goal: goal
        )
        let viewController = AddGoalController(
            mode: mode,
            viewModel: viewModel,
            goal: goal
        )
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func presentDatePicker(dateSubject: CurrentValueSubject<Date, Never>) {
        let dateVC = DatePickerViewController(mode: .goal, dateSubject: dateSubject)
        dateVC.modalPresentationStyle = .formSheet
        navigationController.present(dateVC, animated: true)
    }
    
    func dismissScreen() {
        navigationController.popViewController(animated: true)
    }
    
    func goToGoalsScreen() {
        navigationController.popToRootViewController(animated: true)
    }
}
