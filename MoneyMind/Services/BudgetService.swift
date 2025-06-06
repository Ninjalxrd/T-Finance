//
//  BudgetService.swift
//  MoneyMind
//
//  Created by Павел on 05.06.2025.
//

import Foundation
import Combine
import Alamofire

protocol BudgetServiceProtocol {
    func postBudget(
        amount: Double,
        dayOfAdditionOfBudget: Date
    ) -> AnyPublisher<Void, Error>
    
    func postBudgetDistribution(
        distributions: [BudgetDistributionPayload]
    ) -> AnyPublisher<Void, Error>
}

final class BudgetService: BudgetServiceProtocol {
    // MARK: - Properties
    
    private let baseURL: URL
    private let session: NetworkSessionProtocol
    private let tokenManager: TokenManagerProtocol
    
    // MARK: - Initialization
    
    init(
        baseURL: URL = URL(string: "https://t-bank-finance.ru")!,
        session: NetworkSessionProtocol,
        tokenManager: TokenManagerProtocol
    ) {
        self.baseURL = baseURL
        self.session = session
        self.tokenManager = tokenManager
    }
    
    func postBudget(
        amount: Double,
        dayOfAdditionOfBudget: Date
    ) -> AnyPublisher<Void, Error> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        let date = dateFormatter.string(from: dayOfAdditionOfBudget)
        
        let parameters: [String: Any] = [
            "amount": amount,
            "dayOfAdditionOfBudget": date
        ]
        
        return Future<Void, Error> { [weak self] promise in
            guard let self else {
                promise(.failure(NetworkError.invalidResponse))
                return
            }
            
            Task {
                var headers: HTTPHeaders = ["Content-Type": "application/json"]
                if let token = await self.tokenManager.accessToken {
                    headers.add(name: "Authorization", value: "Bearer \(token)")
                }
                
                self.session.request(
                    self.baseURL.appendingPathComponent("/api/v1/budget"),
                    method: .post,
                    headers: headers,
                    parameters: parameters,
                    encoding: JSONEncoding.default
                )
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        if
                            let statusCode = response.response?.statusCode,
                            (200...204).contains(statusCode) {
                            promise(.success(()))
                        } else {
                            promise(
                                .failure(
                                    NetworkError.httpError(
                                        statusCode: response.response?.statusCode ?? 0
                                    )
                                )
                            )
                        }
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func postBudgetDistribution(
        distributions: [BudgetDistributionPayload]
    ) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard let self else {
                promise(.failure(NetworkError.invalidResponse))
                return
            }
            
            Task {
                var headers: HTTPHeaders = ["Content-Type": "application/json"]
                if let token = await self.tokenManager.accessToken {
                    headers.add(name: "Authorization", value: "Bearer \(token)")
                }
                let jsonData = try JSONEncoder().encode(distributions)
                var urlRequest = URLRequest(
                    url: self.baseURL.appendingPathComponent("/api/v1/budget/distributions")
                )
                urlRequest.method = .post
                urlRequest.headers = headers
                urlRequest.httpBody = jsonData
                self.session.request(urlRequest)
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        if
                            let statusCode = response.response?.statusCode,
                            (200...204).contains(statusCode) {
                            promise(.success(()))
                        } else {
                            promise(
                                .failure(
                                    NetworkError.httpError(
                                        statusCode: response.response?.statusCode ?? 0
                                    )
                                )
                            )
                        }
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

struct BudgetDistributionPayload: Codable {
    let categoryId: Int
    let percent: Int
    let notificationLimit: Int
}

enum DistributionError: Error {
    case invalidPayload
    case unauthorized
    case categoryNotFound
}
