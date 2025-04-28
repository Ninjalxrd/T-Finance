//
//  AppCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 22.04.2025.
//
import UIKit

protocol Coordinator: AnyObject {
    func start()
    var childCoordinators: [Coordinator] { get set }
}

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let windowScene: UIWindowScene
    var childCoordinators = [Coordinator]()
    
    init(window: UIWindow, windowScene: UIWindowScene) {
        self.window = window
        self.windowScene = windowScene
    }
    
    func start() {
        let userManager = UserManager.shared
        if !userManager.isRegistered {
            startAuthFlow()
        } else if !userManager.hasIncome {
            startBudgetInputFlow()
        } else {
            startMainFlow()
        }
    }

    
    // изменить на стартовый экран
    private func startAuthFlow() {
        let confirmationCoordinator = ConfirmationCoordinator(window: window)
        childCoordinators.append(confirmationCoordinator)
        confirmationCoordinator.start()
    }
    
    private func startBudgetInputFlow() {
        let budgetInputCoordinator = BudgetInputCoordinator(window: window)
        childCoordinators.append(budgetInputCoordinator)
        budgetInputCoordinator.start()
    }
    
    private func startMainFlow() {
        
    }
}


extension Coordinator {
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
