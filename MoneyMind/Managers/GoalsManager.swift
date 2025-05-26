//
//  GoalsManager.swift
//  MoneyMind
//
//  Created by Павел on 16.05.2025.
//

import Combine
import UIKit

final class GoalsManager {
    
    // MARK: - Published Properties
    
    @Published var allGoals: [Goal] = []
    
    // MARK: - Methods
    
    func fetchFromServer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.allGoals = [
                Goal(
                    name: "Porsche 911 GT3S",
                    description: "Какое-то описание там",
                    targetAmount: 33000000,
                    currentAmount: 11400500
                ),
                Goal(
                    name: "Квартира",
                    description: "Спавн нужен",
                    targetAmount: 16540000,
                    currentAmount: 2450400
                ),
                Goal(
                    name: "Касарь)",
                    description: "цель номер 3",
                    targetAmount: 1000,
                    currentAmount: 1000
                ),
                Goal(
                    name: "Цель номер 4",
                    description: "цель номер 4",
                    targetAmount: 200000,
                    currentAmount: 0
                )
            ]
        }
    }
}
