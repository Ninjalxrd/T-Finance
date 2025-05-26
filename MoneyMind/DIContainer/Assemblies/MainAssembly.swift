//
//  MainAssembly.swift
//  MoneyMind
//
//  Created by Павел on 20.05.2025.
//

import Swinject
import UIKit

final class MainAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(ExpencesManager.self) { _ in
            ExpencesManager()
        }
        .inObjectScope(.container)
        
        container.register(GoalsManager.self) { _ in
            GoalsManager()
        }
        .inObjectScope(.container)
        
        container.register(MainCoordinator.self) { (resolver, navController: UINavigationController) in
            MainCoordinator(navigationController: navController, resolver: resolver)
        }

        container.register(MainViewModel.self) { resolver in
            guard
                let expencesManager = resolver.resolve(ExpencesManager.self),
                let goalsManager = resolver.resolve(GoalsManager.self)
                    
            else {
                fatalError("Failed to resolve dependencies for MainViewModel")
            }
            return MainViewModel(expencesManager: expencesManager, goalsManager: goalsManager)
        }
        
        container.register(MainViewController.self) { resolver in
            guard let viewModel = resolver.resolve(MainViewModel.self) else {
                fatalError("Failed to resolve MainViewModel for MainViewController")
            }
            return MainViewController(viewModel: viewModel)
        }
    }
}
