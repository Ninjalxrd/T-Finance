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
    private var enterNameCoordinator: EnterNameCoordinator?
    var childCoordinators: [Coordinator] = []
    private var number: String?

    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        guard let number else {
            assertionFailure("Number must be set for start Confirmation screen")
            return
        }
        let confirmationViewModel = ConfirmationViewModel(coordinator: self, phoneNumber: number)
        let confirmationViewController = ConfirmationViewController(viewModel: confirmationViewModel, number: number)
        navigationController.setViewControllers([confirmationViewController], animated: true)
    }
    
    func start(with number: String) {
        self.number = number
        start()
    }
        
    // MARK: - Public Methods
        
    func openEnterNameScreen() {
        enterNameCoordinator = EnterNameCoordinator(navigationController: navigationController)
        enterNameCoordinator?.start()
    }
}
