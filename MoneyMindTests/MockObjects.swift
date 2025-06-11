//
//  MockObjects.swift
//  MoneyMindTests
//
//  Created by Павел on 09.06.2025.
//

import XCTest
import Combine
@testable import MoneyMind

final class ExpencesServiceMock: ExpencesServiceProtocol {
    var shouldReturnError = false
    var transactionsToReturn = Transactions(transactions: [], totalAmount: 0)
    var categoriesToReturn = SumByCategoryOfPeriodWrapper(sumOfAllTransactions: 0, categories: [])
    var balanceToReturn = BudgetBalance(balance: 0)
    
    func fetchExpenses(
        startDate: Date,
        endDate: Date,
        categoryId: Int?,
        page: Int,
        pageSize: Int
    ) -> AnyPublisher<Transactions, Error> {
        if shouldReturnError {
            return Fail(error: MockError()).eraseToAnyPublisher()
        }
        return Just(transactionsToReturn)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchBudgetBalance() -> AnyPublisher<BudgetBalance, Error> {
        if shouldReturnError {
            return Fail(error: MockError()).eraseToAnyPublisher()
        }
        return Just(balanceToReturn)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchExpensesByCategory(
        startDate: Date,
        endDate: Date,
        page: Int,
        pageSize: Int
    ) -> AnyPublisher<SumByCategoryOfPeriodWrapper, Error> {
        fatalError("Not used in this test")
    }

    func fetchCategories() -> AnyPublisher<[TransactionCategory], Error> {
        fatalError("Not used in this test")
    }

    func deleteTransaction(id: Int) -> AnyPublisher<Void, Error> {
        fatalError("Not used in this test")
    }

    func addTransaction(
        name: String,
        date: Date,
        categoryId: Int,
        amount: Double,
        description: String
    ) -> AnyPublisher<Void, Error> {
        fatalError("Not used in this test")
    }
    
    struct MockError: Error {}
}

final class GoalsServiceMock: GoalsServiceProtocol {
    var shouldReturnError = false
    var goalsToReturn: [Goal] = []
    
    func fetchGoals() -> AnyPublisher<[Goal], Error> {
        if shouldReturnError {
            return Fail(error: MockError()).eraseToAnyPublisher()
        }
        return Just(goalsToReturn)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func postGoal(name: String, term: Date, amount: Double, description: String) -> AnyPublisher<Void, Error> { fatalError() }
    func patchGoal(id: Int, name: String, term: Date, amount: Double, description: String) -> AnyPublisher<Void, Error> { fatalError() }
    func getGoalById(id: Int) -> AnyPublisher<Goal, Error> { fatalError() }
    func deleteGoal(id: Int) -> AnyPublisher<Void, Error> { fatalError() }
    
    struct MockError: Error {}
}

final class MainCoordinatorSpy: MainCoordinatorProtocol {
    private(set) var didStart = true
    private(set) var didOpenExpenses = false
    private(set) var didOpenGoals = false
    
    func start() { didStart = true }
    func openExpencesScreen() { didOpenExpenses = true }
    func openGoalsScreen() { didOpenGoals = true }
}

enum NotificationManagerSpy {
    static var didSendBudgetLimit = false
    static func sendBudgetLimitNotification() { didSendBudgetLimit = true }
}

extension TransactionCategory {
    static func mock() -> TransactionCategory {
        return TransactionCategory(
            id: 1,
            name: "Food",
            color: "F00000"
        )
    }
}
