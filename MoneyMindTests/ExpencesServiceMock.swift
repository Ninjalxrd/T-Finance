//
//  ExpencesViewModelTests.swift
//  MoneyMindTests
//
//  Created by Павел on 09.06.2025.
//

import XCTest
import Combine
import UIKit
@testable import MoneyMind

final class ExpencesViewModelTests: XCTestCase {
    var viewModel: ExpencesViewModel!
    var expencesServiceMock: ExpencesServiceMock!
    var imageServiceMock: ImageServiceMock!
    var coordinatorMock: ExpencesCoordinatorMock!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        expencesServiceMock = ExpencesServiceMock()
        imageServiceMock = ImageServiceMock()
        coordinatorMock = ExpencesCoordinatorMock()
        viewModel = ExpencesViewModel(
            coordinator: coordinatorMock,
            expencesService: expencesServiceMock,
            imageService: imageServiceMock
        )
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        expencesServiceMock = nil
        imageServiceMock = nil
        coordinatorMock = nil
        cancellables = nil
        super.tearDown()
    }

    func testInitialLoad() {
        let mockCategories = [Category(id: 1, name: "Test", backgroundColor: "000000", percent: 50, money: 100, isPicked: false)]

        expencesServiceMock.transactionsToReturn = Transactions(
            transactions: [Expence.mock()],
            totalAmount: 100
        )
        expencesServiceMock.categoriesToReturn = SumByCategoryOfPeriodWrapper(
            sumOfAllTransactions: 100,
            categories: [
                SumByCategoryOfPeriod(category: mockCategories[0], sum: 100, percentageOfAllTransactions: 50)
            ]
        )

        let expectationExpences = XCTestExpectation(description: "Expenses loaded")
        let expectationCategories = XCTestExpectation(description: "Categories loaded")

        viewModel.$expences
            .dropFirst()
            .sink { expences in
                XCTAssertEqual(expences.count, 1)
                XCTAssertEqual(expences.first?.id, 1)
                expectationExpences.fulfill()
            }
            .store(in: &cancellables)

        viewModel.$expensesCategories
            .dropFirst()
            .sink { categories in
                XCTAssertEqual(categories.count, 1)
                XCTAssertEqual(categories.first?.name, "Test")
                expectationCategories.fulfill()
            }
            .store(in: &cancellables)

        viewModel.refreshData()
        wait(for: [expectationExpences, expectationCategories], timeout: 1.0)
    }

    func testPeriodChangeTriggersReload() {
        expencesServiceMock.transactionsToReturn = Transactions(transactions: [], totalAmount: 0)
        expencesServiceMock.categoriesToReturn = SumByCategoryOfPeriodWrapper(
            sumOfAllTransactions: 0,
            categories: []
        )

        let expectation = XCTestExpectation(description: "Reload on period change")

        viewModel.$expences
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.setPeriod(.week)

        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadNextPage() {
        expencesServiceMock.transactionsToReturn = Transactions(
            transactions: [Expence.mock(id: 1)],
            totalAmount: 100
        )
        expencesServiceMock.categoriesToReturn = SumByCategoryOfPeriodWrapper(
            sumOfAllTransactions: 0,
            categories: []
        )

        let loadExpectation = XCTestExpectation(description: "Initial load")
        viewModel.$expences
            .dropFirst()
            .sink { _ in
                loadExpectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.refreshData()
        wait(for: [loadExpectation], timeout: 1)

        expencesServiceMock.transactionsToReturn = Transactions(
            transactions: [Expence.mock(id: 2)],
            totalAmount: 200
        )

        let nextPageExpectation = XCTestExpectation(description: "Load next page appends data")
        viewModel.$expences
            .dropFirst(2)
            .sink { expences in
                XCTAssertTrue(expences.contains(where: { $0.id == 2 }))
                nextPageExpectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.loadNextPageIfNeeded(currentIndex: viewModel.expences.count - 1)

        wait(for: [nextPageExpectation], timeout: 1)
    }

    func testGetImageByURLCallsService() {
        let imageExpectation = XCTestExpectation(description: "Image service called")
        imageServiceMock.downloadImageCalled = false

        viewModel.getImageByURL("test_url") { image in
            imageExpectation.fulfill()
        }

        XCTAssertTrue(imageServiceMock.downloadImageCalled)
        wait(for: [imageExpectation], timeout: 1)
    }
}

final class ImageServiceMock: ImageServiceProtocol {
    var downloadImageCalled = false
    func downloadImage(by url: String?, completion: @escaping (UIImage?) -> Void) {
        downloadImageCalled = true
        completion(nil)
    }
}

final class ExpencesCoordinatorMock: ExpencesCoordinatorProtocol {
    func start() {
    }
}

extension TransactionCategory {
    static func mock(id: Int = 1,
                     name: String = "Food",
                     color: String = "FF0000") -> TransactionCategory {
        .init(id: id, name: name, color: color)
    }
}

extension Expence {
    static func mock(id: Int = 1,
                     amount: Double = 100,
                     category: TransactionCategory = .mock()) -> Expence {
        .init(id: id,
              name: "test",
              date: Date(),
              category: category,
              amount: amount,
              description: "desc")
    }
}
