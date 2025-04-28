//
//  ConfirmationCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 24.04.2025.
//

import Foundation
import UIKit

final class ConfirmationCoordinator: Coordinator {
    // MARK: - Properties
    var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    let navigationController: UINavigationController
    private var enterNameCoordinator: EnterNameCoordinator?

    // MARK: - Init
    
    // изменить
    init(window: UIWindow) {
        self.navigationController = UINavigationController()
        self.window = window
    }
        
    // with navigationController
    func start() {
        let confirmationViewModel = ConfirmationViewModel(coordinator: self)
        let confirmationViewController = ConfirmationViewController(viewModel: confirmationViewModel)
        navigationController.setViewControllers([confirmationViewController], animated: true)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
        
    // MARK: - Public Methods
        
    func openEnterNameScreen() {
        enterNameCoordinator = EnterNameCoordinator()
        enterNameCoordinator?.start()
    }
}
