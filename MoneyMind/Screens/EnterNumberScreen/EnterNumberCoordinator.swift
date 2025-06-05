//
//  EnterNumberCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 23.04.2025.
//

import UIKit

final class EnterNumberCoordinator: Coordinator {
    // MARK: - Private Properties
    
    private(set) var navigationController: UINavigationController
    private var confirmationCoordinator: ConfirmationCoordinator?
    private let diContainer: AppDIContainer
    var childCoordinators: [Coordinator] = []

    // MARK: - Initialization
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    // MARK: - Public Methods
    
    func start() {
        let enterNumberViewModel = EnterNumberViewModel(coordinator: self, diContainer: diContainer)
        let enterNumberController = EnterNumberController(viewModel: enterNumberViewModel)
        navigationController.setViewControllers([enterNumberController], animated: true)
    }
    
    // MARK: - Navigation Methods
    
    func openConfirmationScreen(with number: String) {
        confirmationCoordinator = ConfirmationCoordinator(
            navigationController: navigationController,
            diContainer: diContainer
        )
        confirmationCoordinator?.start(with: number)
    }
}
