//
//  ConfirmationCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 24.04.2025.
//

import Foundation
import UIKit

// MARK: - Protocols
protocol ConfirmationCoordinatorProtocol: AnyObject {
    func openEnterNameScreen()
}

final class ConfirmationCoordinator: Coordinator {
    // MARK: - Properties
    
    private(set) var navigationController: UINavigationController
    private let diContainer: AppDIContainer
    private var enterNameCoordinator: EnterNameCoordinator?
    var childCoordinators: [Coordinator] = []
    private unowned let window: UIWindow
    private var number: String?

    // MARK: - Init
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer, window: UIWindow) {
        self.navigationController = navigationController
        self.diContainer = diContainer
        self.window = window
    }

    func start() {
        guard let number else {
            assertionFailure("Number must be set for start Confirmation screen")
            return
        }
        let keychainManager = diContainer.resolve(KeychainManagerProtocol.self)
        let authService = diContainer.resolve(AuthServiceProtocol.self)
        
        let confirmationViewModel = ConfirmationViewModel(
            coordinator: self,
            phoneNumber: number,
            diContainer: diContainer,
            keychainManager: keychainManager,
            authService: authService
        )
        let confirmationViewController = ConfirmationViewController(viewModel: confirmationViewModel, number: number)
        navigationController.setViewControllers([confirmationViewController], animated: true)
    }
    
    func start(with number: String) {
        self.number = number
        start()
    }
        
    // MARK: - Public Methods
        
    func openEnterNameScreen() {
        enterNameCoordinator = EnterNameCoordinator(
            navigationController: navigationController,
            diContainer: diContainer,
            window: window
        )
        enterNameCoordinator?.start()
    }
}
