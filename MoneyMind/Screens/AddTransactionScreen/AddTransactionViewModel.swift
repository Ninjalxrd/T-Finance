//
//  AddTransactionViewModel.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import Combine
import Foundation

final class AddTransactionViewModel {
    // MARK: - Properties
    var coordinator: AddTransactionCoordinator?
    var expenceService: ExpencesServiceProtocol

    // MARK: - Published Properties
    
    @Published var amount: String = ""
    let categorySubject = CurrentValueSubject<TransactionCategory?, Never>(nil)
    let dateSubject = CurrentValueSubject<Date, Never>(Date())
    var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($amount, categorySubject)
            .map { amount, category in
                let isAmountValid = Double(amount).map { $0 > 0 } ?? false
                let isCategorySelected = category != nil
                return isAmountValid && isCategorySelected
            }
            .eraseToAnyPublisher()
    }
    private var bag: Set<AnyCancellable> = []
    
    // MARK: - Init
    
    init(coordinator: AddTransactionCoordinator, expenceService: ExpencesServiceProtocol) {
        self.coordinator = coordinator
        self.expenceService = expenceService
    }
    
    // MARK: - Public Methods
    
    func openCategoriesScreen() {
        coordinator?.openCategoriesScreen(categorySubject)
    }
    
    func openDatePicker() {
        coordinator?.presentDatePicker(dateSubject: dateSubject)
    }
    
    func addNewTransaction() {
        guard
            let categoryId = categorySubject.value?.id,
            let doubleAmount = Double(amount)
        else {
            return
        }
        expenceService.addTransaction(
            name: "Добавленная транзакция",
            date: dateSubject.value,
            categoryId: categoryId,
            amount: doubleAmount,
            description: "Custom Transaction"
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            if case .failure(let error) = completion {
                print("Error post new transaction:", error.localizedDescription)
                return
            }
            
            self?.coordinator?.dismissScreen()
        } receiveValue: { _ in }
        .store(in: &bag)
    }
}
