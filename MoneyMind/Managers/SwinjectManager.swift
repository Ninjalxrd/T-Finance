//
//  SwinjectManager.swift
//  MoneyMind
//
//  Created by Павел on 20.05.2025.
//

import Swinject
import Alamofire
import UIKit

protocol DIContainer {
    func resolveMainViewModel() -> MainViewModel
    func resolveMainController(navigationController: UINavigationController) -> MainViewController
}

final class SwinjectManager: DIContainer {
    private let container: Container

    init() {
        container = Container()
        setupDependencies()
    }
    
    func resolveMainController(navigationController: UINavigationController) -> MainViewController {
        guard let controller = container.resolve(MainViewController.self, argument: navigationController) else {
            fatalError("MainViewController dependency could not be resolved")
        }
        return controller
    }
    
    func resolveMainViewModel() -> MainViewModel {
        guard let viewModel = container.resolve(MainViewModel.self) else {
            fatalError("MainViewModel dependency could not be resolved")
        }
        return viewModel
    }
    
    private func setupDependencies() {
        container.register(KeychainManagerProtocol.self) { _ in
            KeychainManager()
        }
        .inObjectScope(.container)
        
        container.register(TokenManager.self) { resolver in
            guard let keychainManager = resolver.resolve(KeychainManagerProtocol.self) else {
                fatalError("KeychainManager dependency could not be resolved")
            }
            return TokenManager(keychainManager: keychainManager)
        }
        .inObjectScope(.container)
        
        container.register(ExpencesService.self) { resolver in
            guard let tokenManager = resolver.resolve(TokenManager.self) else {
                fatalError("TokenManager dependency could not be resolved")
            }
            return ExpencesService(session: Session(
                configuration: .default,
                interceptor: tokenManager
            ))
        }
        .inObjectScope(.container)
        
        container.register(MainCoordinator.self) { (_, navController: UINavigationController) in
            MainCoordinator(navigationController: navController)
        }

        container.register(MainViewModel.self) { (resolver, navController: UINavigationController) in
            guard
                let manager = resolver.resolve(ExpencesService.self),
                let coordinator = resolver.resolve(MainCoordinator.self, argument: navController)
            else {
                fatalError("Failed to resolve dependencies for MainViewModel")
            }
            return MainViewModel(coordinator: coordinator, expencesManager: manager)
        }
        
        container.register(MainViewController.self) { (resolver, navController: UINavigationController) in
            guard let viewModel = resolver.resolve(MainViewModel.self, argument: navController) else {
                fatalError("Failed to resolve MainViewModel for MainViewController")
            }
            return MainViewController(viewModel: viewModel)
        }
    }
}
