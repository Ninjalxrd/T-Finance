//
//  GoalsViewModel.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import Foundation
import Combine
import UIKit

final class GoalsViewModel {
    // MARK: - Properties
    
    private var coordinator: GoalsCoordinatorProtocol?
    private let goalsService: GoalsServiceProtocol
    private var bag: Set<AnyCancellable> = []
    let didAddGoal = PassthroughSubject<Void, Never>()
    @Published var goals: [Goal] = []

    // MARK: - Init
    
    init(coordinator: GoalsCoordinatorProtocol, goalsService: GoalsServiceProtocol) {
        self.coordinator = coordinator
        self.goalsService = goalsService
        getGoals()
        onAddGoal()
    }
    
    private func onAddGoal() {
        didAddGoal
            .sink { [weak self] in
                self?.getGoals()
            }
            .store(in: &bag)
    }
    
    private func getGoals() {
        goalsService.fetchGoals()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error fetching goals:", error.localizedDescription)
                }
            } receiveValue: { [weak self] fetchingGoals in
                guard let self else { return }
                self.goals = fetchingGoals
            }
            .store(in: &bag)
    }
    
    func deleteGoal(id: Int) {
        goalsService.deleteGoal(
            id: id
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case .failure(let error) = completion {
                print("Error fetching goals:", error.localizedDescription)
            }
        } receiveValue: { _ in
        }
        .store(in: &bag)
    }
    
    func openAddGoalScreen() {
        coordinator?.openNewGoalScreen(didAddGoal)
    }
    
    func openDetailGoalScreen(goal: Goal) {
        coordinator?.openDetailGoalScreen(goal: goal, didAddGoal)
    }
}
