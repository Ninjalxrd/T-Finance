//
//  TokenManager.swift
//  MoneyMind
//
//  Created by Павел on 28.05.2025.
//

import Foundation
import Combine
import Alamofire

protocol TokenManagerProtocol: RequestInterceptor, Sendable {
    var accessToken: String? { get async }
    func refreshToken() -> AnyPublisher<String, Error>
    func setSession(_ session: Session)
}

private actor TokenState {
    var accessToken: String?
    
    func updateToken(_ token: String?) {
        accessToken = token
    }
}

private actor SessionState {
    var session: Session?
    
    func setSession(_ session: Session?) {
        self.session = session
    }
}

final class TokenManager: TokenManagerProtocol, RequestInterceptor {
    // MARK: - Properties
    
    private let keychainManager: KeychainManagerProtocol
    private let baseURL: URL
    private let sessionState: SessionState
    private let tokenState: TokenState
    
    // MARK: - Public Properties
    
    var accessToken: String? {
        get async {
            await tokenState.accessToken
        }
    }
    
    var session: Session? {
        get async {
            await sessionState.session
        }
    }
    
    // MARK: - Initialization
    
    init(
        keychainManager: KeychainManagerProtocol,
        baseURL: URL = URL(string: "https://t-bank-finance.ru")!
    ) {
        self.keychainManager = keychainManager
        self.baseURL = baseURL
        self.tokenState = TokenState()
        self.sessionState = SessionState()
        Task {
            await tokenState.updateToken(keychainManager.getAccessToken())
        }
    }
    
    // MARK: - Public Methods
    
    func setSession(_ session: Alamofire.Session) {
        Task {
            await sessionState.setSession(session)
        }
    }
    
    func saveTokens(accessToken: String, refreshToken: String) {
        keychainManager.saveAccessToken(accessToken)
        keychainManager.saveRefreshToken(refreshToken)
        Task {
            await tokenState.updateToken(accessToken)
        }
    }
    
    func clearTokens() {
        keychainManager.saveAccessToken("")
        keychainManager.saveRefreshToken("")
        Task {
            await tokenState.updateToken(nil)
        }
    }
    
    func refreshToken() -> AnyPublisher<String, Error> {
        guard let refreshToken = keychainManager.getRefreshToken() else {
            return Fail(error: TokenError.noRefreshToken).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(refreshToken)"
        ]
        
        return Future<String, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(TokenError.invalidResponse))
                return
            }
            Task {
                guard let session = await self.session else {
                    promise(.failure(TokenError.invalidResponse))
                    return
                }
                
                session.request(
                    self.baseURL.appendingPathComponent("/api/v1/auth/refresh-token"),
                    method: .post,
                    headers: headers
                )
                .responseDecodable(of: TokenResponse.self) { [weak self] response in
                    switch response.result {
                    case .success(let tokenResponse):
                        self?.saveTokens(
                            accessToken: tokenResponse.accessToken,
                            refreshToken: tokenResponse.refreshToken
                        )
                        promise(.success(tokenResponse.accessToken))
                        
                    case .failure(let error):
                        if
                            let statusCode = response.response?.statusCode,
                            statusCode == 401 {
                            self?.clearTokens()
                            promise(.failure(TokenError.refreshTokenExpired))
                        } else {
                            promise(.failure(error))
                        }
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    // MARK: - Request Adapter
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>
        ) -> Void
    ) {
        var urlRequest = urlRequest
        
        Task {
            if let token = await tokenState.accessToken {
                urlRequest.headers.add(.authorization(bearerToken: token))
            }
            completion(.success(urlRequest))
        }
    }
}

// MARK: - Token Response

private struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
        case tokenType
    }
}

// MARK: - Token Error

enum TokenError: LocalizedError {
    case noRefreshToken
    case refreshTokenExpired
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .noRefreshToken:
            return "Отсутствует токен обновления"
        case .refreshTokenExpired:
            return "Срок действия токена обновления истек"
        case .invalidResponse:
            return "Неверный ответ от сервера"
        }
    }
}

// MARK: - Request Extension

private extension Request {
    private static var cancellablesKey: UInt8 = 0
    
    var cancellables: Set<AnyCancellable> {
        get {
            if let cancellables = objc_getAssociatedObject(self, &Self.cancellablesKey) as? Set<AnyCancellable> {
                return cancellables
            }
            let cancellables = Set<AnyCancellable>()
            self.cancellables = cancellables
            return cancellables
        }
        set {
            objc_setAssociatedObject(self, &Self.cancellablesKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

// MARK: - Request Retrier

extension TokenManager: RequestRetrier {
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult
        ) -> Void
    ) {
        guard
            let response = request.response,
            response.statusCode == 401,
            request.retryCount == 0 else {
            completion(.doNotRetry)
            return
        }
        
        refreshToken()
            .sink(
                receiveCompletion: { result in
                    if case .failure = result {
                        completion(.doNotRetry)
                    }
                },
                receiveValue: { _ in
                    completion(.retry)
                }
            )
            .store(in: &request.cancellables)
    }
}
