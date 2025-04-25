//
//  EnterNameCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 25.04.2025.
//

import UIKit
final class EnterNameCoordinator {
    // MARK: - Properties

    let navigationController: UINavigationController
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: Methods
    
    func start() {
        let viewModel = EnterNameViewModel(coordinator: self)
        let enterNameViewController = EnterNameViewController(viewModel: viewModel)
        navigationController.pushViewController(enterNameViewController, animated: true)
    }
}
