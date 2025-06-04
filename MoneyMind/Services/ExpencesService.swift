//
//  ExpencesService.swift
//  MoneyMind
//
//  Created by Павел on 28.05.2025.
//

import Foundation
import Combine
import Alamofire

protocol ExpencesServiceProtocol {
    func fetchExpenses(
        startDate: Date,
        endDate: Date,
        categoryId: Int?,
        page: Int,
        pageSize: Int
    ) -> AnyPublisher<Transactions, Error>
    func fetchExpensesByCategory(
        startDate: Date,
        endDate: Date,
        page: Int,
        pageSize: Int
    ) -> AnyPublisher<SumByCategoryOfPeriodWrapper, Error>
    func fetchCategories() -> AnyPublisher<[TransactionCategory], Error>
    func deleteTransaction(id: Int) -> AnyPublisher<Void, Error>
    func addTransaction(
        name: String,
        date: Date,
        categoryId: Int,
        amount: Double,
        description: String
    ) -> AnyPublisher<Void, Error>
}

final class ExpencesService: ExpencesServiceProtocol {
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
    
    // MARK: - Public Methods
    
    func fetchExpenses(
        startDate: Date,
        endDate: Date,
        categoryId: Int?,
        page: Int,
        pageSize: Int
    ) -> AnyPublisher<Transactions, Error> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var parameters: [String: Any] = [
            "startDate": dateFormatter.string(from: startDate),
            "endDate": dateFormatter.string(from: endDate),
            "page": page,
            "pageSize": pageSize
        ]
        
        if let categoryId = categoryId {
            parameters["categoryId"] = categoryId
        }
        
        return performRequest(
            path: "/api/v1/transactions",
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.queryString
        )
    }
    
    func fetchExpensesByCategory(
        startDate: Date,
        endDate: Date,
        page: Int,
        pageSize: Int
    ) -> AnyPublisher<SumByCategoryOfPeriodWrapper, Error> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let parameters: [String: Any] = [
            "startDate": dateFormatter.string(from: startDate),
            "endDate": dateFormatter.string(from: endDate),
            "page": page,
            "pageSize": pageSize
        ]
        
        return performRequest(
            path: "/api/v1/transactions/by-category",
            method: .get,
            parameters: parameters
        )
    }
    
    func fetchCategories() -> AnyPublisher<[TransactionCategory], Error> {
        return performRequest(
            path: "/api/v1/categories",
            method: .get
        )
    }
    
    func deleteTransaction(id: Int) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NetworkError.invalidResponse))
                return
            }
            
            self.session.request(
                self.baseURL.appendingPathComponent("/api/v1/transactions/\(id)"),
                method: .delete,
                headers: nil,
                parameters: nil,
                encoding: nil
            )
            .response { response in
                switch response.result {
                case .success:
                    if
                        let statusCode = response.response?.statusCode,
                        (200...204).contains(statusCode) {
                        promise(.success(()))
                    } else {
                        promise(.failure(NetworkError.httpError(statusCode: response.response?.statusCode ?? 0)))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func addTransaction(
        name: String,
        date: Date,
        categoryId: Int,
        amount: Double,
        description: String = ""
    ) -> AnyPublisher<Void, Error> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let payload: [String: Any] = [
            "name": name,
            "date": dateFormatter.string(from: date),
            "categoryId": categoryId,
            "amount": amount,
            "description": description
        ]
        print("Payload: \(payload)")

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
                    self.baseURL.appendingPathComponent("/api/v1/transactions"),
                    method: .post,
                    headers: headers,
                    parameters: payload,
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
                            promise(.failure(NetworkError.httpError(statusCode: response.response?.statusCode ?? 0)))
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

    // MARK: - Private Methods
    
    private func performRequest<T: Decodable>(
        path: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.queryString
    ) -> AnyPublisher<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NetworkError.invalidResponse))
                return
            }
            
            var headers: HTTPHeaders = [:]
            Task {
                if let token = await self.tokenManager.accessToken {
                    headers.add(name: "Authorization", value: "Bearer \(token)")
                }
                
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                self.session.request(
                    self.baseURL.appendingPathComponent(path),
                    method: method,
                    headers: headers,
                    parameters: parameters,
                    encoding: encoding
                )
                .validate()
                .responseDecodable(of: T.self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure(let error):
                        if
                            let data = response.data,
                            let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                            promise(.failure(NetworkError.apiError(apiError)))
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
}

// MARK: - Network Error

enum NetworkError: LocalizedError {
    case invalidResponse
    case httpError(statusCode: Int)
    case apiError(APIError)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Неверный ответ от сервера"
        case .httpError(let statusCode):
            return "Ошибка HTTP: \(statusCode)"
        case .apiError(let error):
            return error.message
        case .decodingError(let error):
            return "Ошибка декодирования: \(error.localizedDescription)"
        }
    }
}

// MARK: - API Error

struct APIError: Codable {
    let message: String
    let code: String?
    let details: [String: String]?
}

// MARK: - SumByCategoryOfPeriodWrapper

struct SumByCategoryOfPeriodWrapper: Codable {
    let sumOfAllTransactions: Double
    let categories: [SumByCategoryOfPeriod]
}

struct SumByCategoryOfPeriod: Codable {
    let category: TransactionCategory
    let sum: Double
    let percentageOfAllTransactions: Double
}

// MARK: - TransactionsWrapper

struct Transactions: Codable {
    let transactions: [Expence]
    let totalAmount: Double
}
