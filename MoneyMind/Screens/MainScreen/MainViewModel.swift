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
    @Published private(set) var goalsState: GoalsViewState = .loading
    @Published private(set) var lastExpences: [Expence] = []
    @Published private(set) var lastGoals: [Goal] = []

    // MARK: - Properties
    
    var coordinator: MainCoordinator?
    private var bag: Set<AnyCancellable> = []
    private let expencesManager = ExpencesManager.shared
    private let goalsManager = GoalsManager.shared

    // MARK: - Init
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        getLastExpences()
        getLastGoals()
    }
    
    private func getLastExpences() {
        expencesManager.fetchFromServer()
        expencesManager.$allExpences
            .receive(on: DispatchQueue.main)
            .sink { [weak self] expences in
                guard let self else { return }
                if expences.isEmpty {
                    self.expencesState = .loading
                } else {
                    self.lastExpences = Array(expences.prefix(3))
                    self.expencesState = .content(lastExpences)
                }
            }
            .store(in: &bag)
    }
    
    private func getLastGoals() {
        goalsManager.fetchFromServer()
        goalsManager.$allGoals
            .receive(on: DispatchQueue.main)
            .sink { [weak self] goals in
                guard let self else { return }
                if goals.isEmpty {
                    self.expencesState = .loading
                } else {
                    self.lastGoals = Array(goals.prefix(3))
                    self.goalsState = .content(lastGoals)
                }
            }
            .store(in: &bag)
    }
}
