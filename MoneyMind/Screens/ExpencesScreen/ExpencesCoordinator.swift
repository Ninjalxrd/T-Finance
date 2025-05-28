//
//  ExpencesCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit

final class ExpencesCoordinator {
    // MARK: - Properties
    
    private(set) var navigationController: UINavigationController
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Public Methods
    
    func start() {
        let container = SwinjectManager()
        let expencesService = container.
        let expencesViewModel = ExpencesViewModel(coordinator: self)
        let expencesContoller = ExpencesController(viewModel: expencesViewModel)
        navigationController.pushViewController(expencesContoller, animated: true)
    }
}
