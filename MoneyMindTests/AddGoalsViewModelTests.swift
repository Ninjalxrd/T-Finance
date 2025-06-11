//
//  AddGoalsViewModelTests.swift
//  MoneyMindTests
//
//  Created by Павел on 09.06.2025.
//

import XCTest
import Combine
@testable import MoneyMind

// MARK: - Spies & Mocks
final class AddGoalCoordinatorSpy: AddGoalCoordinatorProtocol {
    private(set) var didPresentDatePicker = false
    private(set) var didDismissScreen = false
    private(set) var didGoToGoalsScreen = false

    func presentDatePicker(dateSubject: CurrentValueSubject<Date, Never>) {
        didPresentDatePicker = true
        dateSubject.send(Date())
    }
    func dismissScreen() { didDismissScreen = true }
    func goToGoalsScreen() { didGoToGoalsScreen = true }
}

final class GoalsServiceSpy: GoalsServiceProtocol {
    var postCalled = false
    var patchCalled = false
    var capturedPostParams: PostGoalParams?
    var capturedPatchParams: PatchGoalParams?

    func getGoalById(id: Int) -> AnyPublisher<Goal, Error> { fatalError() }
    func fetchGoals() -> AnyPublisher<[Goal], Error> { fatalError() }
    func deleteGoal(id: Int) -> AnyPublisher<Void, Error> { fatalError() }

    func postGoal(
        name: String, term: Date, amount: Double, description: String
    ) -> AnyPublisher<Void, Error> {
        postCalled = true
        var capturedPostParams: PostGoalParams?
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func patchGoal(
        id: Int, name: String, term: Date,
        amount: Double, description: String
    ) -> AnyPublisher<Void, Error> {
        patchCalled = true
        var capturedPatchParams: PatchGoalParams?
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

// MARK: - Tests
final class AddGoalViewModelTests: XCTestCase {

    private var bag: Set<AnyCancellable> = []

    func testFormValidation() {
        let vm = makeViewModel(mode: .create)
        var results: [Bool] = []

        vm.isFormValid
            .sink { results.append($0) }
            .store(in: &bag)

        vm.nameText = "iPhone"
        vm.amountText = "1500"
        vm.descriptionText = "12 Pro"
        vm.dateWasPicked = true

        RunLoop.main.run(until: Date().addingTimeInterval(0.01))

        XCTAssertTrue(results.last ?? false, "Форма должна стать валидной")
    }

    func testOpenDatePicker() {
        let (vm, coordinator, _) = makeViewModelReturnAll(mode: .create)
        vm.openDatePicker()
        XCTAssertTrue(coordinator.didPresentDatePicker)
        XCTAssertTrue(vm.dateWasPicked)
    }

    func testSaveGoal_Create() {
        let (vm, coordinator, service) = makeViewModelReturnAll(mode: .create)

        vm.nameText = "MacBook"
        vm.amountText = "2000"
        vm.descriptionText = "Air M3"
        vm.date = Date()
        vm.dateWasPicked = true

        vm.saveGoal()

        XCTAssertTrue(service.postCalled)
        XCTAssertTrue(coordinator.didDismissScreen)
    }

    func testSaveGoal_Edit() {
        let goal = Goal(id: 7, name: "Old", term: Date().description, amount: 10, accumulatedAmount: 0, description: "")
        let (vm, coordinator, service) = makeViewModelReturnAll(mode: .edit, goal: goal)

        vm.nameText = "Tesla"
        vm.amountText = "30000"
        vm.descriptionText = "Model 3"
        vm.date = Date()
        vm.dateWasPicked = true

        vm.saveGoal()

        XCTAssertTrue(service.patchCalled)
        XCTAssertTrue(coordinator.didGoToGoalsScreen)
    }

    // MARK: - helpers
    @discardableResult
    private func makeViewModel(
        mode: GoalViewMode,
        goal: Goal? = nil
    ) -> AddGoalViewModel {
        AddGoalViewModel(
            coordinator: AddGoalCoordinatorSpy(),
            goalsService: GoalsServiceSpy(),
            goalSubject: .init(),
            mode: mode,
            goal: goal
        )
    }

    private func makeViewModelReturnAll(
        mode: GoalViewMode,
        goal: Goal? = nil
    ) -> (AddGoalViewModel, AddGoalCoordinatorSpy, GoalsServiceSpy) {
        let coordinator = AddGoalCoordinatorSpy()
        let service     = GoalsServiceSpy()
        let vm = AddGoalViewModel(
            coordinator: coordinator,
            goalsService: service,
            goalSubject: .init(),
            mode: mode,
            goal: goal
        )
        return (vm, coordinator, service)
    }
}

struct PostGoalParams: Equatable {
    let name: String
    let term: Date
    let amount: Double
    let description: String
}

struct PatchGoalParams: Equatable {
    let id: Int
    let name: String
    let term: Date
    let amount: Double
    let description: String
}
