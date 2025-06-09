//
//  MainViewModelTests.swift
//  MoneyMindTests
//
//  Created by Павел on 09.06.2025.
//

import XCTest
import Combine
@testable import MoneyMind

final class MainViewModelTests: XCTestCase {
    private var expencesServiceMock: ExpencesServiceMock!
    private var goalsServiceMock: GoalsServiceMock!
    private var imageServiceMock: ImageServiceMock!
    private var coordinatorSpy: MainCoordinatorSpy!
    
    private var viewModel: MainViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        
        expencesServiceMock = ExpencesServiceMock()
        goalsServiceMock = GoalsServiceMock()
        imageServiceMock = ImageServiceMock()
        coordinatorSpy = MainCoordinatorSpy()
        
        viewModel = MainViewModel(
            expencesService: expencesServiceMock,
            goalsService: goalsServiceMock,
            coordinator: coordinatorSpy,
            imageService: imageServiceMock
        )
        
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        viewModel = nil
        expencesServiceMock = nil
        goalsServiceMock = nil
        imageServiceMock = nil
        coordinatorSpy = nil
        
        super.tearDown()
    }
    
    func testGetLastExpences_Success() {
        let expectation = XCTestExpectation(description: "Expenses loaded")
        
        let mockExpences = [
            Expence(
                id: 1,
                name: "Coffee",
                date: Date(),
                category: .mock(),
                amount: 100,
                description: "Morning coffee"
            )
        ]
        
        expencesServiceMock.transactionsToReturn = Transactions(transactions: mockExpences, totalAmount: 100)
        
        viewModel.$expencesState
            .dropFirst()
            .sink { state in
                if case .content(let content) = state {
                    XCTAssertEqual(content.count, 1)
                    XCTAssertEqual(content.first?.amount, 100)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.getLastExpences()
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testGetLastExpences_Error() {
        let expectation = XCTestExpectation(description: "Expenses error")
        expencesServiceMock.shouldReturnError = true

        viewModel.$expencesState
            .dropFirst()
            .sink { state in
                if case .error(let message) = state {
                    XCTAssertEqual(message, "Mock Error")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.getLastExpences()
        wait(for: [expectation], timeout: 1.0)
    }

    func testOpenExpencesScreen_CallsCoordinator() {
        viewModel.openExpencesScreen()
        XCTAssertTrue(coordinatorSpy.didOpenExpenses)
    }

    func testOpenGoalsScreen_CallsCoordinator() {
        viewModel.openGoalsScreen()
        XCTAssertTrue(coordinatorSpy.didOpenGoals)
    }
}
