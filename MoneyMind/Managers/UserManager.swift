//
//  UserManager.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import Foundation

final class UserManager {
    // MARK: - Singleton
    
    static let shared = UserManager()
    private init() {}
    
    // MARK: - UserDefaults Initialization
    
    private let userDefaults = UserDefaults.standard
    private let isRegisteredKey = "isRegistered"
    private let hasIncomeKey = "hasIncome"
    private let budgetKey = "userBudget"
    private let categoriesKey = "categories"
    
    // MARK: - Get/Set Properties
    
    var theme: Theme {
        get {
            Theme(rawValue: UserDefaults.standard.integer(forKey: "selectedTheme")) ?? .dark
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTheme")
        }
    }
    
    var isRegistered: Bool {
        get {
            userDefaults.bool(forKey: isRegisteredKey)
        }
        set {
            userDefaults.set(newValue, forKey: isRegisteredKey)
        }
    }
    
    var hasIncome: Bool {
        get {
            userDefaults.bool(forKey: hasIncomeKey)
        }
        set {
            userDefaults.set(newValue, forKey: hasIncomeKey)
        }
    }
    
    var budget: Int {
        get {
            userDefaults.integer(forKey: budgetKey)
        }
        set {
            userDefaults.set(newValue, forKey: budgetKey)
        }
    }
    
    var categories: [Category] {
        get {
            guard
                let data = userDefaults.data(forKey: categoriesKey),
                let decoded = try? JSONDecoder().decode([Category].self, from: data)
            else {
                return []
            }
            return decoded
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                userDefaults.set(encoded, forKey: categoriesKey)
            }
        }
    }
    
    // MARK: - Public Methods
    
    func clearUserData() {
        userDefaults.removeObject(forKey: isRegisteredKey)
        userDefaults.removeObject(forKey: hasIncomeKey)
    }
}
