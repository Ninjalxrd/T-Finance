//
//  AddTransactionViewModel.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

final class AddTransactionViewModel {
    // MARK: - Properties
    
    var coordinator: AddTransactionCoordinator?

    // MARK: - Init
    
    init(coordinator: AddTransactionCoordinator) { self.coordinator = coordinator }
    
    // MARK: - Public Methods
    func openCategoriesScreen() {
        coordinator?.openCategoriesScreen()
    }
}
