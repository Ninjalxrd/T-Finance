//
//  CategoriesCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 03.06.2025.
//

import UIKit

final class CategoriesCoordinator: Coordinator {
    let navigationController: UINavigationController
    let diContainer: AppDIContainer
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start() {
        let expencesService = diContainer.resolve(ExpencesServiceProtocol.self)
        let imageService = diContainer.resolve(ImageServiceProtocol.self)
        let categoriesViewModel = CategoriesViewModel(
            coordinator: self,
            expencesService: expencesService,
            imageService: imageService
        )
        
        let categoriesViewController = CategoriesViewController(
            viewModel: categoriesViewModel
        )
        navigationController.present(categoriesViewController, animated: true)
    }
}
