//
//  MainViewModel.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import Combine
import Foundation

final class MainViewModel {
    // MARK: - Published Properties
    
    @Published private(set) var expencesState: ExpencesViewState = .loading
    @Published private(set) var lastExpences: [Expence] = []
    @Published private(set) var goalsState: GoalsViewState = .loading
    @Published private(set) var lastGoals: [Goal] = []

    // MARK: - Properties
    
    var coordinator: MainCoordinator?
    private var bag: Set<AnyCancellable> = []
    private let expencesService: ExpencesServiceProtocol
    private let goalsManager: GoalsManagerProtocol

    // MARK: - Init
    
    init(expencesService: ExpencesServiceProtocol, goalsManager: GoalsManagerProtocol, coordinator: MainCoordinator) {
        self.expencesService = expencesService
        self.goalsManager = goalsManager
        self.coordinator = coordinator
        getLastExpences()
        getLastGoals()
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
                self.lastExpences = expences
                self.expencesState = .content(self.lastExpences)
            }
        )
        .store(in: &bag)
    }
    
    func getLastGoals() {
        goalsManager.fetchFromServer()
        goalsManager.allGoalsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] goals in
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
    
    // MARK: - Public Methods
    
    func openExpencesScreen() {
        coordinator?.openExpencesScreen()
    }
}
