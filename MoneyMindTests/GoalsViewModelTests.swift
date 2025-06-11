//
//  GoalsViewModelTests.swift
//  MoneyMindTests
//
//  Created by Павел on 09.06.2025.
//

import XCTest
import Combine
@testable import MoneyMind

final class GoalsViewModelTests: XCTestCase {
    var viewModel: GoalsViewModel!
    var goalsServiceMock: GoalsServiceMock!
    var coordinatorMock: GoalsCoordinatorMock!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        goalsServiceMock = GoalsServiceMock()
        coordinatorMock = GoalsCoordinatorMock()
        viewModel = GoalsViewModel(coordinator: coordinatorMock, goalsService: goalsServiceMock)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        goalsServiceMock = nil  
        coordinatorMock = nil
        cancellables = nil
        super.tearDown()
    }

    func testGoalsLoadedOnInit() {
        let mockGoals = [
            Goal(id: 1, name: "Test Goal 1", term: Date().description, amount: 1000, accumulatedAmount: 500, description: "Description 1"),
            Goal(id: 2, name: "Test Goal 2", term: Date().description, amount: 2000, accumulatedAmount: 2000, description: "Description 2")
        ]
        goalsServiceMock.goalsToReturn = mockGoals

        let expectation = XCTestExpectation(description: "Goals loaded")

        viewModel.$goals
            .dropFirst()
            .sink { goals in
                XCTAssertEqual(goals.count, 2)
                XCTAssertEqual(goals.first?.name, "Test Goal 1")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testDidAddGoalTriggersReload() {
        let mockGoals = [
            Goal(id: 3, name: "New Goal", term: Date().description, amount: 3000, accumulatedAmount: 2000, description: "Description 3")
        ]
        goalsServiceMock.goalsToReturn = mockGoals

        let expectation = XCTestExpectation(description: "Goals reloaded on didAddGoal")

        viewModel.$goals
            .dropFirst(2)
            .sink { goals in
                XCTAssertEqual(goals.count, 1)
                XCTAssertEqual(goals.first?.id, 3)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.didAddGoal.send(())

        wait(for: [expectation], timeout: 1.0)
    }
}

final class GoalsCoordinatorMock: GoalsCoordinatorProtocol {
    func start() {
    }
    
    func openNewGoalScreen(_ didAddGoal: PassthroughSubject<Void, Never>) {
    }
    func openDetailGoalScreen(goal: Goal, _ didAddGoal: PassthroughSubject<Void, Never>) {
    }
}
