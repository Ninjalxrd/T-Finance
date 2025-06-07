//
//  AddGoalCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 06.06.2025.
//

import UIKit
import Combine

final class AddGoalCoordinator {
    private let navigationController: UINavigationController
    private let diContainer: AppDIContainer
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start(mode: GoalViewMode, didAddGoal: PassthroughSubject<Void, Never>) {
        let goalsService = diContainer.resolve(GoalsServiceProtocol.self)
        let viewModel = AddGoalViewModel(
            coordinator: self,
            goalsService: goalsService,
            goalSubject: didAddGoal
        )
        let viewController = AddGoalController(mode: mode, viewModel: viewModel)
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
}
