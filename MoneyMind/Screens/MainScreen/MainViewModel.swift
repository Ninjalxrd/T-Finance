//
//  MainViewModel.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import Combine
import Foundation
import UIKit

final class MainViewModel {
    // MARK: - Published Properties
    
    @Published private(set) var expencesState: ExpencesViewState = .loading
    @Published private(set) var lastExpences: [Expence] = []
    @Published private(set) var goalsState: GoalsViewState = .loading
    @Published private(set) var lastGoals: [Goal] = []
    @Published private(set) var balance: Int = 0

    // MARK: - Properties
    
    var coordinator: MainCoordinatorProtocol?
    private var bag: Set<AnyCancellable> = []
    private let expencesService: ExpencesServiceProtocol
    private let goalsService: GoalsServiceProtocol
    private let imageService: ImageServiceProtocol

    // MARK: - Init
    
    init(
        expencesService: ExpencesServiceProtocol,
        goalsService: GoalsServiceProtocol,
        coordinator: MainCoordinatorProtocol,
        imageService: ImageServiceProtocol
    ) {
        self.expencesService = expencesService
        self.goalsService = goalsService
        self.coordinator = coordinator
        self.imageService = imageService
        getLastExpences()
        getLastGoals()
        getBalance()
    }
    
    // MARK: - Public Methods
    
    func getLastExpences() {
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: endDate) ?? endDate
        
        expencesService.fetchExpenses(
            startDate: startDate,
            endDate: endDate,
            categoryId: nil,
            page: 1,
            pageSize: 3
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.expencesState = .error(error.localizedDescription)
                }
            },
            receiveValue: { [weak self] expences in
                guard let self else { return }
                if expences.transactions.isEmpty {
                    self.expencesState = .loading
                }
                self.lastExpences = expences.transactions
                self.expencesState = .content(self.lastExpences)
            }
        )
        .store(in: &bag)
    }
    
    func getLastGoals() {
        goalsService.fetchGoals()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.expencesState = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] goals in
                guard let self else { return }
                if goals.isEmpty {
                    self.goalsState = .loading
                } else {
                    self.lastGoals = Array(goals.prefix(3))
                    self.goalsState = .content(lastGoals)
                }
            }
            .store(in: &bag)
            }
    
    func getImageByURL(_ url: String?, completion: @escaping (UIImage?) -> Void) {
        imageService.downloadImage(by: url) { image in
            completion(image)
        }
    }
    
    func getBalance() {
        expencesService.fetchBudgetBalance()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("error with fetch budget balance \(error)")
                }
            } receiveValue: { [weak self] balance in
                self?.balance = Int(balance.balance)
                self?.tryToSendNotfication(
                    currentBalance: balance.balance,
                    totalBalance: Double(UserManager.shared.budget)
                )
            }
            .store(in: &bag)
    }
    
    private func tryToSendNotfication(currentBalance: Double, totalBalance: Double) {
        if currentBalance / totalBalance >= 0.9 {
            NotificationManager.sendBudgetLimitNotification()
        }
    }
    
    // MARK: - Public Methods
    
    func openExpencesScreen() {
        coordinator?.openExpencesScreen()
    }
    
    func openGoalsScreen() {
        coordinator?.openGoalsScreen()
    }
}
