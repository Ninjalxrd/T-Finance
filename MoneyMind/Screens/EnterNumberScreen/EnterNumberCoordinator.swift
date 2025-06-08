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
    private unowned let window: UIWindow
    private let diContainer: AppDIContainer
    var childCoordinators: [Coordinator] = []

    // MARK: - Initialization
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer, window: UIWindow) {
        self.navigationController = navigationController
        self.diContainer = diContainer
        self.window = window
    }
    
    // MARK: - Public Methods
    
    func start() {
        let authService = diContainer.resolve(AuthServiceProtocol.self)
        let enterNumberViewModel = EnterNumberViewModel(coordinator: self, authService: authService)
        let enterNumberController = EnterNumberController(viewModel: enterNumberViewModel)
        navigationController.setViewControllers([enterNumberController], animated: true)
    }
    
    // MARK: - Navigation Methods
    
    func openConfirmationScreen(with number: String) {
        confirmationCoordinator = ConfirmationCoordinator(
            navigationController: navigationController,
            diContainer: diContainer,
            window: window
        )
        confirmationCoordinator?.start(with: number)
    }
}
