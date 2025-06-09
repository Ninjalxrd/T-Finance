//
//  AddGoalViewModel.swift
//  MoneyMind
//
//  Created by Павел on 06.06.2025.
//

import Foundation
import Combine

final class AddGoalViewModel {
    // MARK: - Properties
    
    private var coordinator: AddGoalCoordinatorProtocol?
    private var bag: Set<AnyCancellable> = []
    private let goalsService: GoalsServiceProtocol
    private let mode: GoalViewMode
    private let goal: Goal?
    let dateSubject = CurrentValueSubject<Date, Never>(Date())
    let goalSubject: PassthroughSubject<Void, Never>
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
        coordinator: AddGoalCoordinatorProtocol?,
        goalsService: GoalsServiceProtocol,
        goalSubject: PassthroughSubject<Void, Never>,
        mode: GoalViewMode,
        goal: Goal?
    ) {
        self.coordinator = coordinator
        self.goalsService = goalsService
        self.goalSubject = goalSubject
        self.mode = mode
        self.goal = goal
        setupDependency()
    }
    
    private func setupDependency() {
        dateSubject
            .dropFirst()
            .sink { [weak self] date in
                self?.date = date
                self?.dateWasPicked = true
            }
            .store(in: &bag)
    }

    func openDatePicker() {
        coordinator?.presentDatePicker(dateSubject: dateSubject)
    }
    
    func saveGoal() {
        if mode == .create {
            guard
                let date,
                let amount = Double(amountText)
            else { return }
            postGoal(
                name: nameText,
                term: date,
                amount: amount,
                description: descriptionText
            )
        } else if mode == .edit {
            guard
                let date,
                let amount = Double(amountText),
                let goal
            else { return }
            patchGoal(
                id: goal.id,
                name: nameText,
                term: date,
                amount: amount,
                description: descriptionText
            )
        } else {
            return
        }
    }
    
    func postGoal(
        name: String,
        term: Date,
        amount: Double,
        description: String
    ) {
        goalsService.postGoal(
            name: name,
            term: term,
            amount: amount,
            description: description
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            if case .failure(let error) = completion {
                print("Error fetching goals:", error.localizedDescription)
            } else {
                self?.goalSubject.send()
                self?.coordinator?.dismissScreen()
            }
        } receiveValue: { _ in
        }
        .store(in: &bag)
    }
    
    func patchGoal(
        id: Int,
        name: String,
        term: Date,
        amount: Double,
        description: String
    ) {
        goalsService.patchGoal(
            id: id,
            name: name,
            term: term,
            amount: amount,
            description: description
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            if case .failure(let error) = completion {
                print("Error patch goals:", error.localizedDescription)
            } else {
                self?.goalSubject.send()
                self?.coordinator?.goToGoalsScreen()
            }
        } receiveValue: { _ in
        }
        .store(in: &bag)
    }
}
