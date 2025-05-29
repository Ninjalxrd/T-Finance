//
//  ServicesAssembly.swift
//  MoneyMind
//
//  Created by Павел on 28.05.2025.
//

import Swinject
import Alamofire
import Foundation

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Session
        
        container.register(Session.self) { _ in
            let configuration = URLSessionConfiguration.af.default
            let interceptor = container.resolve(TokenManagerProtocol.self)
            return Session(configuration: configuration, interceptor: interceptor)
        }
        .inObjectScope(.container)
        
        // MARK: - Token Manager
        
        container.register(TokenManagerProtocol.self) { resolver in
            guard let keychainManager = resolver.resolve(KeychainManagerProtocol.self) else {
                fatalError("Failed to resolve KeychainManagerProtocol")
            }
            guard let baseURL = URL(string: "https://t-bank-finance.ru") else {
                fatalError("Failed to get URL")
            }
            guard let session = resolver.resolve(Session.self) else {
                fatalError("Failed to resolve Session")
            }
            return TokenManager(
                keychainManager: keychainManager,
                baseURL: baseURL,
                session: session
            )
        }
        .inObjectScope(.container)
        
        // MARK: - Keychain Manager
        
        container.register(KeychainManagerProtocol.self) { _ in
            KeychainManager()
        }
        .inObjectScope(.container)
        
        // MARK: - Expences Service
        
        container.register(ExpencesServiceProtocol.self) { resolver in
            guard let baseURL = URL(string: "https://t-bank-finance.ru") else {
                fatalError("Failed to get URL")
            }
            guard let session = resolver.resolve(Session.self) else {
                fatalError("Failed to resolve Session")
            }
            return ExpencesService(
                baseURL: baseURL,
                session: session
            )
        }
        .inObjectScope(.container)
    }
}
