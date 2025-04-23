//
//  ProcentDetailsViewModel.swift
//  MoneyMind
//
//  Created by Павел on 19.04.2025.
//

import Combine

final class ProcentDetailsViewModel {
    // MARK: - Properties
    let remainingPercentLimit: Int
    private let totalBudget: Int
    
    // MARK: - Published Properties

    @Published private(set) var moneyValue: Int = 0
    @Published private(set) var remainingValue: Int = 0
    @Published private(set) var remainingPercent: Int
    
    // MARK: - Init

    init(remainingValue: Int, remainingPercent: Int) {
        self.remainingValue = remainingValue
        self.remainingPercent = remainingPercent
        self.remainingPercentLimit = remainingPercent
        self.totalBudget = remainingValue
        updateValues(value: 0)
    }
    
    // MARK: - Public methods
    
    func updateValues(value: Int) {
        let percent = Double(value) / Double(remainingPercentLimit)
        moneyValue = Int(Double(totalBudget) * percent)
        remainingValue = totalBudget - moneyValue
        remainingPercent = remainingPercentLimit - value
    }
}
