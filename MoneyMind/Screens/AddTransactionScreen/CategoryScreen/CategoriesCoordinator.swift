//
//  CategoriesCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 03.06.2025.
//

import UIKit
import Combine

final class CategoriesCoordinator: Coordinator {
    let navigationController: UINavigationController
    let diContainer: AppDIContainer
    let categorySubject: CurrentValueSubject<TransactionCategory?, Never>

    init(
        navigationController: UINavigationController,
        diContainer: AppDIContainer,
        categorySubject: CurrentValueSubject<TransactionCategory?, Never>
    ) {
        self.navigationController = navigationController
        self.diContainer = diContainer
        self.categorySubject = categorySubject
    }
    
    func start() {
        let expencesService = diContainer.resolve(ExpencesServiceProtocol.self)
        let imageService = diContainer.resolve(ImageServiceProtocol.self)
        let categoriesViewModel = CategoriesViewModel(
            coordinator: self,
            expencesService: expencesService,
            imageService: imageService,
            categorySubject: categorySubject
        )
        
        let categoriesViewController = CategoriesViewController(
            viewModel: categoriesViewModel
        )
        navigationController.present(categoriesViewController, animated: true)
    }
    
    func dismissScreen() {
        navigationController.dismiss(animated: true)
    }
}
