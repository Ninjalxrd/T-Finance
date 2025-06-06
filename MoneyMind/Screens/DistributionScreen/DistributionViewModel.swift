//
//  DistributionViewModel.swift
//  MoneyMind
//
//  Created by Павел on 17.04.2025.
//

import UIKit
import Combine

final class DistributionViewModel {
    // MARK: - Properties
    weak var coordinator: DistributionCoordinator?
    let expenceService: ExpencesServiceProtocol
    let budgetService: BudgetServiceProtocol
    var totalBudget: Int
    
    // MARK: - Published Properties

    @Published var pickedCategories: [Category] = []
    @Published var availableCategories: [Category] = []
    @Published var remainingPercent: Int = 100
    private var bag: Set<AnyCancellable> = []

    // MARK: - Init
    
    init(
        totalBudget: Int,
        coordinator: DistributionCoordinator,
        expenceService: ExpencesServiceProtocol,
        budgetService: BudgetServiceProtocol
    ) {
        self.coordinator = coordinator
        self.totalBudget = totalBudget
        self.expenceService = expenceService
        self.budgetService = budgetService
        loadCategories()
    }
    
    // MARK: - Private Methods
    
    private func loadCategories() {
        expenceService.fetchCategories()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("error with fetching categories on distribution screen - \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] categories in
                let all: [Category] = categories.map {
                    return Category(
                        id: $0.id,
                        name: $0.name,
                        backgroundColor: $0.color,
                        percent: 0,
                        money: 0,
                        isPicked: false
                    )
                }
                self?.pickedCategories = all.filter { $0.isPicked }
                self?.availableCategories = all.filter { !$0.isPicked }
            }
            .store(in: &bag)
    }
    
    // MARK: - Public Methods

    func selectCategory(from data: Category) {
        var newCategory = data
        newCategory.isPicked = true
        
        pickedCategories.append(newCategory)
        remainingPercent -= data.percent
        totalBudget -= data.money
        
        if let index = availableCategories.firstIndex(where: { $0.name == data.name }) {
            availableCategories.remove(at: index)
        }
    }
    
    func deselectCategory(at indexPath: IndexPath) {
        let category = pickedCategories.remove(at: indexPath.item)
        var available = category
        available.isPicked = false
        remainingPercent += category.percent
        totalBudget += category.money
        
        availableCategories.append(available)
    }
    
    func selectAvailableItem(indexPath: IndexPath) {
        let category = availableCategories[indexPath.item]
        coordinator?.openProcentDetailsScreen(
            budget: totalBudget,
            selectedCategory: category
        )
    }
    
    func showError() {
        coordinator?.showErrorAlert()
    }
    
    func openMainScreen() {
        UserManager.shared.categories = pickedCategories
        postCategories(pickedCategories)
        coordinator?.openMainScreen()
    }
    
    private func postCategories(_ categories: [Category]) {
        if remainingPercent != 0 {
            coordinator?.showWarningAlert()
        }
        let categories = categories.map { category in
            BudgetDistributionPayload(
                categoryId: category.id,
                percent: category.percent,
                notificationLimit: category.notificationLimit
            )
        }
        
        budgetService.postBudgetDistribution(distributions: categories)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("error with fetching categories on distribution screen - \(error.localizedDescription)")
                }
            } receiveValue: { _ in
            }
            .store(in: &bag)
    }
}
