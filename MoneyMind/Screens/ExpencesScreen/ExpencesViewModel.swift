//
//  ExpencesViewModel.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import Foundation
import Combine
import UIKit

final class ExpencesViewModel {
    // MARK: - Properties
    
    let coordinator: ExpencesCoordinator
    private let expencesService: ExpencesServiceProtocol
    private let imageService: ImageServiceProtocol
    private var bag: Set<AnyCancellable> = []
    private let defaultPageSize: Int = 20
    private var currentPage: Int = 1
    private var isLoadingPage = false
    private var allDataLoaded = false
    private var currentStartDate: Date?
    private var currentEndDate: Date?
    
    // MARK: - Published Properties
    
    @Published var expences: [Expence] = []
    @Published var totalExpenses: Double = 0
    @Published var expensesCategories: [Category] = []
    let refreshSubject = PassthroughSubject<Void, Never>()
    let periodSubject = CurrentValueSubject<TimePeriod, Never>(.month)
    
    init(
        coordinator: ExpencesCoordinator,
        expencesService: ExpencesServiceProtocol,
        imageService: ImageServiceProtocol
    ) {
        self.coordinator = coordinator
        self.expencesService = expencesService
        self.imageService = imageService
        
        setupPeriodHandling()
        periodSubject.send(.month)
        refreshSubject.send()
    }
    
    // MARK: - Public Methods
    
    func refreshData() {
        refreshSubject.send()
    }
    
    func setPeriod(_ period: TimePeriod) {
        periodSubject.send(period)
    }
    
    func getImageByURL(_ url: String?, completion: @escaping (UIImage?) -> Void) {
        imageService.downloadImage(by: url) { image in
            completion(image)
        }
    }
    
    func loadNextPageIfNeeded(currentIndex: Int) {
        let thresholdIndex = expences.count - 5
        if currentIndex >= thresholdIndex && !isLoadingPage && !allDataLoaded {
            let nextPage = currentPage + 1
            guard let startDate = currentStartDate, let endDate = currentEndDate else {
                return
            }
            
            getExpences(startDate: startDate, endDate: endDate, page: nextPage, pageSize: defaultPageSize)
        }
    }

    // MARK: - Private Methods

    private func setupPeriodHandling() {
        periodSubject
            .combineLatest(refreshSubject)
            .map { period, _ in period }
            .map { [weak self] period -> (Date, Date) in
                let endDate = Date()
                let startDate: Date
                
                switch period {
                case .day:
                    if let date = Calendar.current.date(byAdding: .day, value: -1, to: endDate) {
                        startDate = date
                    } else {
                        startDate = endDate
                    }
                case .week:
                    if let date = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: endDate) {
                        startDate = date
                    } else {
                        startDate = endDate
                    }
                case .month:
                    if let date = Calendar.current.date(byAdding: .month, value: -1, to: endDate) {
                        startDate = date
                    } else {
                        startDate = endDate
                    }
                case .year:
                    if let date = Calendar.current.date(byAdding: .year, value: -1, to: endDate) {
                        startDate = date
                    } else {
                        startDate = endDate
                    }
                }
                self?.currentStartDate = startDate
                self?.currentEndDate = endDate
                return (startDate, endDate)
            }
            .sink { [weak self] startDate, endDate in
                self?.loadData(startDate: startDate, endDate: endDate)
            }
            .store(in: &bag)
    }
    
    private func loadData(startDate: Date, endDate: Date) {
        currentPage = 1
        allDataLoaded = false
        expences = []
        getExpences(startDate: startDate, endDate: endDate, page: currentPage, pageSize: defaultPageSize)
        getCategoriesOfExpences(startDate: startDate, endDate: endDate, page: 1, pageSize: 100000)
    }
    
    private func getExpences(startDate: Date, endDate: Date, page: Int, pageSize: Int) {
        guard !isLoadingPage, !allDataLoaded else { return }
        
        isLoadingPage = true
        
        expencesService.fetchExpenses(
            startDate: startDate,
            endDate: endDate,
            categoryId: nil,
            page: page,
            pageSize: pageSize
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            guard let self else { return }
            self.isLoadingPage = false
            if case .failure(let error) = completion {
                print("Error fetching expenses:", error.localizedDescription)
            }
        } receiveValue: { [weak self] expences in
            guard let self else { return }
            if expences.transactions.isEmpty {
                self.allDataLoaded = true
            } else {
                if page == 1 {
                    self.expences = expences.transactions
                } else {
                    self.expences.append(contentsOf: expences.transactions)
                }
                self.currentPage = page
            }
        }
        .store(in: &bag)
    }
    
    private func getCategoriesOfExpences(startDate: Date, endDate: Date, page: Int, pageSize: Int) {
        expencesService.fetchExpensesByCategory(
            startDate: startDate,
            endDate: endDate,
            page: page,
            pageSize: pageSize
        )
        .sink { completion in
            if case .failure(let error) = completion {
                print("chart error: \(error)")
            }
        }
        receiveValue: { [weak self] wrapper in
            let categories = wrapper.categories.map {
                Category(
                    id: $0.category.id,
                    name: $0.category.name,
                    backgroundColor: $0.category.color,
                    percent: Int($0.percentageOfAllTransactions.rounded()),
                    money: Int($0.sum.rounded()),
                    isPicked: false
                )
            }
            self?.totalExpenses = wrapper.sumOfAllTransactions
            self?.expensesCategories = categories
        }
        .store(in: &bag)
    }
    
//
}

enum TimePeriod: Int, CaseIterable {
    case day = 0
    case week
    case month
    case year
    
    var title: String {
        switch self {
        case .day:
            return "День"
        case .week:
            return "Неделя"
        case .month:
            return "Месяц"
        case .year:
            return "Год"
        }
    }
}

enum MonthYear: Int, CaseIterable {
    case january = 1
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december

    static private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "LLLL"
        return formatter
    }()

    var title: String {
        var components = DateComponents()
        components.month = self.rawValue
        let date = Calendar.current.date(from: components) ?? Date()
        return Self.formatter.string(from: date).capitalized
    }
}

extension MonthYear {
    static func currentMonth() -> MonthYear {
        let currentMonthNumber = Calendar.current.component(.month, from: Date())
        return MonthYear(rawValue: currentMonthNumber) ?? .january
    }
}
