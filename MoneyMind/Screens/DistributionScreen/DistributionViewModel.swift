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
    var totalBudget: Int
    
    // MARK: - Published Properties

    @Published var pickedCategories: [Category] = []
    @Published var availableCategories: [Category] = []
    @Published var remainingPercent: Int = 100

    // MARK: - Init
    
    init(totalBudget: Int, coordinator: DistributionCoordinator) {
        self.coordinator = coordinator
        self.totalBudget = totalBudget
        loadMockCategories()
    }
    
    // MARK: - Private Methods
    
    private func loadMockCategories() {
        let all = [
            Category(
                id: 1,
                name: "Еда",
                backgroundColor: "#FFDD2D",
                percent: 0,
                money: 0,
                isPicked: false
            ),
            Category(
                id: 2,
                name: "Транспорт",
                backgroundColor: "#FF983D",
                percent: 0,
                money: 0,
                isPicked: false
            ),
            Category(
                id: 3,
                name: "Развлечения",
                backgroundColor: "#3DBBFF",
                percent: 0,
                money: 0,
                isPicked: false
            ),
            Category(
                id: 4,
                name: "Одежда",
                backgroundColor: "#ff75f7",
                percent: 0,
                money: 0,
                isPicked: false
            ),
            Category(
                id: 5,
                name: "Авиабилеты",
                backgroundColor: "#75eaff",
                percent: 0,
                money: 0,
                isPicked: false
            ),
            Category(
                id: 6,
                name: "Переводы",
                backgroundColor: "#98de16",
                percent: 0,
                money: 0,
                isPicked: false
            )
        ]
        
        pickedCategories = all.filter { $0.isPicked }
        availableCategories = all.filter { !$0.isPicked }
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
}
