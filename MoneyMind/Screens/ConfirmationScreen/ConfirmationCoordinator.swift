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

final class ConfirmationCoordinator {
    // MARK: - Properties
    
    private(set) var navigationController: UINavigationController
    private var enterNameCoordinator: EnterNameCoordinator?

    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
        
    func start(with number: String) {
        let confirmationViewModel = ConfirmationViewModel(coordinator: self)
        let confirmationViewController = ConfirmationViewController(viewModel: confirmationViewModel, number: number)
        navigationController.setViewControllers([confirmationViewController], animated: true)
    }
        
    // MARK: - Public Methods
        
    func openEnterNameScreen() {
        enterNameCoordinator = EnterNameCoordinator(navigationController: navigationController)
        enterNameCoordinator?.start()
    }
}
