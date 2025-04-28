//
//  EnterNameCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 25.04.2025.
//

import UIKit

final class EnterNameCoordinator: Coordinator {
    // MARK: - Properties

    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    // MARK: - Init
    
    init() {
        self.navigationController = UINavigationController()
    }
    
    // MARK: Methods
    
    func start() {
        let viewModel = EnterNameViewModel(coordinator: self)
        let enterNameViewController = EnterNameViewController(viewModel: viewModel)
        navigationController.pushViewController(enterNameViewController, animated: true)
    }
}
