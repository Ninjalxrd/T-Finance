//
//  ExpencesCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit
import Swinject

final class ExpencesCoordinator {
    // MARK: - Properties
    
    private(set) var navigationController: UINavigationController
    private let resolver: Resolver
    
    // MARK: - Init
    
    init(navigationController: UINavigationController, resolver: Resolver) {
        self.navigationController = navigationController
        self.resolver = resolver
    }
    
    // MARK: - Public Methods
    
    func start() {
        let expencesService = resolver.safeResolve(ExpencesServiceProtocol.self)
        let expencesViewModel = ExpencesViewModel(coordinator: self, expencesService: expencesService)
        let expencesContoller = ExpencesController(viewModel: expencesViewModel)
        navigationController.pushViewController(expencesContoller, animated: true)
    }
}
