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
    
    @Published private(set) var state: ExpencesViewState = .loading
    @Published private(set) var lastExpences: [Expence] = []
    
    // MARK: - Properties
    
    var coordinator: MainCoordinator?
    private var bag: Set<AnyCancellable> = []
    private let expencesManager: ExpencesManager
    
    // MARK: - Init
    
    init(coordinator: MainCoordinator, expencesManager: ExpencesManager) {
        self.coordinator = coordinator
        self.expencesManager = expencesManager
        getLastExpences()
    }
    
    // MARK: - Private Methods
    
    private func getLastExpences() {
        expencesManager.fetchFromServer()
        expencesManager.$allExpences
            .receive(on: DispatchQueue.main)
            .sink { [weak self] expences in
                guard let self else { return }
                if expences.isEmpty {
                    self.state = .loading
                } else {
                    self.lastExpences = Array(expences.prefix(3))
                    self.state = .content(lastExpences)
                }
            }
            .store(in: &bag)
    }
    
    // MARK: - Public Methods
    
    func openExpencesScreen() {
        coordinator?.openExpencesScreen()
    }
}
