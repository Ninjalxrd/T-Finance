//
//  EnterNumberCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 23.04.2025.
//

import UIKit

final class EnterNumberCoordinator {
    // MARK: - Properties
    
    private(set) var navigationController: UINavigationController
    
    // MARK: - Initialization
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Public Methods
    
    func start() {
        let enterNumberViewModel = EnterNumberViewModel(coordinator: self)
        let enterNumberController = EnterNumberController(viewModel: enterNumberViewModel)
        navigationController.pushViewController(enterNumberController, animated: true)
    }
    
    // MARK: - Navigation Methods
}
