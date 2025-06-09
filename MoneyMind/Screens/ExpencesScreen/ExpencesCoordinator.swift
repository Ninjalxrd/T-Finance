//
//  ExpencesCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit
import Swinject

protocol ExpencesCoordinatorProtocol {
    func start()
}
final class ExpencesCoordinator: ExpencesCoordinatorProtocol {
    // MARK: - Properties
    
    private(set) var navigationController: UINavigationController
    private let diContainer: AppDIContainer
    
    // MARK: - Init
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    // MARK: - Public Methods
    
    func start() {
        let expencesService = diContainer.resolve(ExpencesServiceProtocol.self)
        let imageService = diContainer.resolve(ImageServiceProtocol.self)
        let expencesViewModel = ExpencesViewModel(
            coordinator: self,
            expencesService: expencesService,
            imageService: imageService
        )
        let expencesContoller = ExpencesController(viewModel: expencesViewModel)
        navigationController.pushViewController(expencesContoller, animated: false)
    }
}
