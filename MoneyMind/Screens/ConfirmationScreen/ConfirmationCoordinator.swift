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
    private let window: UIWindow
    private var enterNameCoordinator: EnterNameCoordinator?
    var childCoordinators: [Coordinator] = []
    private var number: String?

    // MARK: - Init
    
    init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
    }

    func start() {
        guard let number else {
            assertionFailure("Number must be set for start Confirmation screen")
            return
        }
        let confirmationViewModel = ConfirmationViewModel(coordinator: self)
        let confirmationViewController = ConfirmationViewController(viewModel: confirmationViewModel, number: number)
        navigationController.setViewControllers([confirmationViewController], animated: true)
    }
    
    func start(with number: String) {
        self.number = number
        start()
    }
        
    // MARK: - Public Methods
        
    func openEnterNameScreen() {
        enterNameCoordinator = EnterNameCoordinator(navigationController: navigationController, window: window)
        enterNameCoordinator?.start()
    }
}
