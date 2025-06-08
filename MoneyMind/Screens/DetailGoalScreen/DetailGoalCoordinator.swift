//
//  DetailGoalCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 07.06.2025.
//

import Foundation
import UIKit

final class DetailGoalCoordinator {
    // MARK: - Properties
    
    private let navigationController: UINavigationController
    private let diContainer: AppDIContainer
    
    // MARK: - Init
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start(goal: Goal) {
        let goalsService = diContainer.resolve(GoalsServiceProtocol.self)
        let detailViewModel = DetailViewModel(
            goal: goal,
            coordinator: self,
            goalsService: goalsService
        )
        let detailGoalController = DetailGoalController(detailViewModel: detailViewModel)
        navigationController.pushViewController(detailGoalController, animated: true)
        
    }
}
