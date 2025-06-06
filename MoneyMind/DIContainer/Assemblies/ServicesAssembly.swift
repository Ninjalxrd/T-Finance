//
//  ServicesAssembly.swift
//  MoneyMind
//
//  Created by Павел on 28.05.2025.
//

import Swinject
import Alamofire
import Foundation

// MARK: - Session Protocol

protocol NetworkSessionProtocol {
    func request(
        _ url: URLConvertible,
        method: HTTPMethod,
        headers: HTTPHeaders?,
        parameters: Parameters?,
        encoding: (any ParameterEncoding)?
    ) -> DataRequest
    
    func request(_ urlRequest: URLRequest) -> DataRequest
}

// MARK: - Session Adapter

final class NetworkServiceAdapter: NetworkSessionProtocol {
    private let session: Session
    
    init(session: Session) {
        self.session = session
    }

    func request(
        _ url: URLConvertible,
        method: HTTPMethod,
        headers: HTTPHeaders?,
        parameters: Parameters?,
        encoding: (any ParameterEncoding)?
    ) -> DataRequest {
        session.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding ?? URLEncoding.default,
            headers: headers
        )
    }
    
    func request(_ urlRequest: URLRequest) -> DataRequest {
        session.request(urlRequest)
    }
}

// MARK: - Services Assembly

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Keychain Manager
        
        container.register(KeychainManagerProtocol.self) { _ in
            print(KeychainManager().getAccessToken() ?? "...")
            return KeychainManager()
        }
        .inObjectScope(.container)
        
        // MARK: - Token Manager
        
        container.register(TokenManagerProtocol.self) { resolver in
            guard let keychainManager = resolver.resolve(KeychainManagerProtocol.self) else {
                fatalError("Error when resolve KeychainManager")
            }
            let baseURL = URL(string: "https://t-bank-finance.ru")!

            return TokenManager(
                keychainManager: keychainManager,
                baseURL: baseURL
            )
        }
        .inObjectScope(.container)
        
        // MARK: - Session
        
        container.register(NetworkSessionProtocol.self) { _ in
            let configuration = URLSessionConfiguration.af.default
            guard let tokenManager = container.resolve(TokenManagerProtocol.self) else {
                fatalError("TokenManagerProtocol not resolved")
            }
            let session = Session(configuration: configuration, interceptor: tokenManager)
            tokenManager.setSession(session)
            
            return NetworkServiceAdapter(session: session)
        }
        .inObjectScope(.container)
        
        // MARK: - Expences Service
        
        container.register(ExpencesServiceProtocol.self) { _ in
            let baseURL = URL(string: "https://t-bank-finance.ru")!
            guard let session = container.resolve(NetworkSessionProtocol.self) else {
                fatalError("Error when resolve KeychainManager")
            }
            guard let tokenManager = container.resolve(TokenManagerProtocol.self) else {
                fatalError("TokenManagerProtocol not resolved")
            }
            return ExpencesService(
                baseURL: baseURL,
                session: session,
                tokenManager: tokenManager
            )
        }
        .inObjectScope(.container)
        
        // MARK: - Budget Service

        container.register(BudgetServiceProtocol.self) { _ in
            guard let session = container.resolve(NetworkSessionProtocol.self) else {
                fatalError("Error when resolve KeychainManager")
            }
            guard let tokenManager = container.resolve(TokenManagerProtocol.self) else {
                fatalError("TokenManagerProtocol not resolved")
            }
            return BudgetService(
                session: session,
                tokenManager: tokenManager
            )
        }
        // MARK: - Image Service
        
        container.register(ImageServiceProtocol.self) { _ in
            ImageService()
        }
        .inObjectScope(.container)
        
        // MARK: - Auth Service
        
        container.register(AuthServiceProtocol.self) { _ in
            guard let tokenManager = container.resolve(TokenManagerProtocol.self) else {
                fatalError("TokenManagerProtocol not resolved")
            }
            guard let session = container.resolve(NetworkSessionProtocol.self) else {
                fatalError("Error when resolve KeychainManager")
            }
            return AuthService(
                session: session,
                tokenManager: tokenManager
            )
        }
    }
}
