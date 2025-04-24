//  BudgetInputViewModel.swift
//  MoneyMind
//
//  Created by Павел on 13.04.2025.
//

import Foundation
import Combine

final class BudgetInputViewModel {
    // MARK: Properties
    var coordinator: BudgetInputCoordinator?
    @Published var incomeText: String = ""

    // MARK: Init
    init(coordinator: BudgetInputCoordinator) { self.coordinator = coordinator }

    // MARK: Validation
    var isInputValid: AnyPublisher<Bool, Never> {
        $incomeText.map { Int($0) ?? 0 >= 1000 }.eraseToAnyPublisher()
    }

    // MARK: Actions
    func nextScreenButtonTapped(with budget: Int) { coordinator?.openDistributionScreen(with: budget) }
}
