//
//  DetailViewModel.swift
//  MoneyMind
//
//  Created by Павел on 07.06.2025.
//

import Foundation
import Combine

final class DetailViewModel {
    // MARK: - Properties
    
    private var coordinator: DetailGoalCoordinator?
    private var bag: Set<AnyCancellable> = []
    private let goalsService: GoalsServiceProtocol
    let didAddGoal: PassthroughSubject<Void, Never>
    let goal: Goal

    // MARK: - Init
    
    init(
        goal: Goal,
        coordinator: DetailGoalCoordinator?,
        goalsService: GoalsServiceProtocol,
        didAddGoal: PassthroughSubject<Void, Never>
    ) {
        self.goal = goal
        self.coordinator = coordinator
        self.goalsService = goalsService
        self.didAddGoal = didAddGoal
    }
    
    func openEditScreen() {
        coordinator?.openEditScreen(didAddGoal: didAddGoal, goal: goal)
    }
}
