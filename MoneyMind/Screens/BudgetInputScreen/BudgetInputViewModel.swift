//  BudgetInputViewModel.swift
//  MoneyMind
//
//  Created by Павел on 13.04.2025.
//

import Foundation
import Combine

final class BudgetInputViewModel {
    // MARK: Properties
    private var coordinator: BudgetInputCoordinator?
    private var budgetService: BudgetServiceProtocol
    @Published var incomeText: String = ""
    private var bag: Set<AnyCancellable> = []

    // MARK: Init
    init(coordinator: BudgetInputCoordinator, budgetService: BudgetServiceProtocol) {
        self.coordinator = coordinator
        self.budgetService = budgetService
    }

    // MARK: Validation
    
    var isInputValid: AnyPublisher<Bool, Never> {
        $incomeText.map { Int($0) ?? 0 >= 1000 }.eraseToAnyPublisher()
    }

    // MARK: Actions
    
    func nextScreenButtonTapped(with budget: Int) {
        UserManager.shared.budget = budget
        UserManager.shared.hasIncome = true
        postBudget(budget)
        coordinator?.openDistributionScreen(with: budget)
    }
    
    func postBudget(_ budget: Int) {
        budgetService.postBudget(
            amount: Double(budget),
            dayOfAdditionOfBudget: Date()
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case .failure(let error) = completion {
                print(" postBudget error:", error)
            }
        } receiveValue: { _ in
            print("Budget saved on server")
        }
        .store(in: &bag)
    }
}
