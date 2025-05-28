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
            let interceptor = container.safeResolve(TokenManagerProtocol.self)
            return Session(configuration: configuration, interceptor: interceptor)
        }
        .inObjectScope(.container)
        
        // MARK: - Token Manager
        
        container.register(TokenManagerProtocol.self) { resolver in
            let keychainManager = resolver.safeResolve(KeychainManagerProtocol.self)
            let baseURL = URL(string: "https://t-bank-finance.ru")!
            let session = resolver.safeResolve(Session.self)
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
            let baseURL = URL(string: "https://t-bank-finance.ru")!
            let session = resolver.safeResolve(Session.self)
            return ExpencesService(
                baseURL: baseURL,
                session: session
            )
        }
        .inObjectScope(.container)
    }
}
