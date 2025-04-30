//
//  AppCoordinator.swift
//  MoneyMind
//
//  Created by Павел on 22.04.2025.
//
import UIKit

final class AppCoordinator {
    var window: UIWindow?
    private var enterNumberCoordinator: EnterNumberCoordinator?
    
    func start(_ scene: UIWindowScene) {
        let window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController()
        let enterNumberCoordinator = EnterNumberCoordinator(navigationController: navigationController)
        self.enterNumberCoordinator = enterNumberCoordinator
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        enterNumberCoordinator.start()
    }
}
