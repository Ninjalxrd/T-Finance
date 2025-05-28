//
//  ExpencesViewModel.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import Foundation
import Combine

final class ExpencesViewModel {
    // MARK: - Properties
    
    let coordinator: ExpencesCoordinator
    private let expencesService: ExpencesService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Published Properties
    
    @Published var expenses: [Expence] = []
    @Published var totalExpenses: Int = 0
    @Published var expensesCategories: [Category] = []
    
    init(coordinator: ExpencesCoordinator, expencesService: ExpencesService) {
        self.coordinator = coordinator
        self.expencesService = expencesService
    }
}
