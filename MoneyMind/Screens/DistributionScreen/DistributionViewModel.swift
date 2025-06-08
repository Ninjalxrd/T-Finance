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
        Publishers.Zip(
            expenceService.fetchCategories(),
            budgetService.fetchBudgetDistributions()
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case .failure(let err) = completion {
                print("distribution load error:", err.localizedDescription)
            }
        } receiveValue: { [weak self] allDTO, distDTO in
            guard let self else { return }
            
            let picked = distDTO.map { dto -> Category in
                Category(
                    id: dto.category.id,
                    name: dto.category.name,
                    backgroundColor: dto.category.color,
                    percent: dto.percent,
                    money: Int(
                        Double(self.totalBudget) *
                        Double(dto.percent) / 100.0),
                    isPicked: true,
                    notificationLimit: dto.notificationLimit
                )
            }
            
            let all = allDTO.map {
                Category(
                    id: $0.id,
                    name: $0.name,
                    backgroundColor: $0.color,
                    percent: 0,
                    money: 0,
                    isPicked: false
                )
            }
            
            let pickedIds = Set(picked.map(\.id))
            let available = all.filter { !pickedIds.contains($0.id) }
            
            self.pickedCategories = picked
            self.availableCategories = available
            self.remainingPercent = 100 - picked.reduce(0) { $0 + $1.percent }
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
        if remainingPercent == 0 {
            finishDistribution()
        } else {
            coordinator?.showWarningAlert { [weak self] in
                self?.finishDistribution()
            }
        }
    }

    private func finishDistribution() {
        let payload = pickedCategories.map { category in
            BudgetDistributionPayload(
                categoryId: category.id,
                percent: category.percent,
                notificationLimit: category.notificationLimit
            )
        }

        budgetService.postBudgetDistribution(distributions: payload)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("error with posting categories on distribution screen - \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] _ in
                UserManager.shared.categories = self?.pickedCategories ?? []
                self?.coordinator?.openMainScreen()
            }
            .store(in: &bag)
    }

    private func postCategories(_ categories: [Category]) {
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
                    print("error with posting categories on distribution screen - \(error.localizedDescription)")
                }
            } receiveValue: { _ in
            }
            .store(in: &bag)
    }
}
