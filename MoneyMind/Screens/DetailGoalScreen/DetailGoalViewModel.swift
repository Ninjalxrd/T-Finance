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
    let goal: Goal
    let dateSubject = CurrentValueSubject<Date, Never>(Date())
    var date: Date?
    
    // MARK: - Published Properties

    @Published var nameText: String = ""
    @Published var descriptionText: String = ""
    @Published var amountText: String = ""
    @Published var dateWasPicked: Bool = false

    var isFormValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(
            $nameText,
            $amountText,
            $descriptionText,
            $dateWasPicked
            )
        .map { name, amount, description, datePicked in
            let isNameValid = !name.isEmpty
            let isAmountValid = Double(amount) != nil && !amount.isEmpty
            let isDescriptionValid = !description.isEmpty
            return isNameValid && isAmountValid && isDescriptionValid && datePicked
        }
        .eraseToAnyPublisher()
    }

    // MARK: - Init
    
    init(
        goal: Goal,
        coordinator: DetailGoalCoordinator?,
        goalsService: GoalsServiceProtocol
    ) {
        self.goal = goal
        self.coordinator = coordinator
        self.goalsService = goalsService
    }
}
