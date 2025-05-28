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
    ) -> AnyPublisher<[Expence], Error>
    func fetchExpensesByCategory(
        startDate: Date,
        endDate: Date,
        page: Int,
        pageSize: Int
    ) -> AnyPublisher<SumByCategoryOfPeriodWrapper, Error>
    func fetchCategories() -> AnyPublisher<[TransactionCategory], Error>
    func deleteTransaction(id: Int) -> AnyPublisher<Void, Error>
}

final class ExpencesService: ExpencesServiceProtocol {
    // MARK: - Properties
    
    private let baseURL: URL
    private let session: Session
    
    // MARK: - Initialization
    
    init(
        baseURL: URL = URL(string: "https://t-bank-finance.ru")!,
        session: Session
    ) {
        self.baseURL = baseURL
        self.session = session
    }
    
    // MARK: - Public Methods
    
    func fetchExpenses(
        startDate: Date,
        endDate: Date,
        categoryId: Int?,
        page: Int,
        pageSize: Int
    ) -> AnyPublisher<[Expence], Error> {
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
            parameters: parameters
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
                method: .delete
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
            
            self.session.request(
                self.baseURL.appendingPathComponent(path),
                method: method,
                parameters: parameters,
                encoding: encoding
            )
            .validate()
            .responseDecodable(of: T.self) { response in
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
