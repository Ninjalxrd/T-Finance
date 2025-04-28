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
    
    // MARK: - Get/Set Properties
    
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
    
    // MARK: - Public Methods
    
    func clearUserData() {
        userDefaults.removeObject(forKey: isRegisteredKey)
        userDefaults.removeObject(forKey: hasIncomeKey)
    }
}
