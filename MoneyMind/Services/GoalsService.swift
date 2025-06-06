//
//  GoalsService.swift
//  MoneyMind
//
//  Created by Павел on 06.06.2025.
//

import Foundation
import Combine
import Alamofire

final class GoalsService {
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
    
    func postGoal(
    name: String,
    term: Date,
    amount: Double,
    description: String
    ) -> AnyPublisher<Void, Error> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: term)
        
        let parameters: [String: Any] = [
            "name": name,
            "term": date,
            "amount": amount,
            "description": description
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
                    self.baseURL.appendingPathComponent("/api/v1/goals"),
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
    
    func patchGoal(
        id: Int,
        name: String,
        term: Date,
        amount: Double,
        description: String
    ) -> AnyPublisher<Void, Error> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: term)
        
        let parameters: [String: Any] = [
            "id": id,
            "name": name,
            "term": date,
            "amount": amount,
            "description": description
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
                    self.baseURL.appendingPathComponent("/api/v1/goals"),
                    method: .patch,
                    headers: headers,
                    parameters: parameters,
                    encoding: JSONEncoding.default
                )
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        if let statusCode = response.response?.statusCode,
                           (200...204).contains(statusCode) {
                            promise(.success(()))
                        } else {
                            promise(.failure(
                                NetworkError.httpError(statusCode: response.response?.statusCode ?? 0)
                            ))
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

    func getGoalById(id: Int) -> AnyPublisher<Goal, Error> {
        return Future<Goal, Error> { [weak self] promise in
            guard let self else {
                promise(.failure(NetworkError.invalidResponse))
                return
            }

            Task {
                var headers: HTTPHeaders = ["Content-Type": "application/json"]
                if let token = await self.tokenManager.accessToken {
                    headers.add(name: "Authorization", value: "Bearer \(token)")
                }

                let url = self.baseURL.appendingPathComponent("/api/v1/goals/\(id)")

                self.session.request(
                    url,
                    method: .get,
                    headers: headers,
                    parameters: nil,
                    encoding: nil
                )
                .validate()
                .responseDecodable(of: Goal.self) { response in
                    switch response.result {
                    case .success(let goal):
                        promise(.success(goal))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    func fetchGoals(
    ) -> AnyPublisher<[Goal], Error> {
        return performRequest(
            path: "/api/v1/goals",
            method: .get
        )
    }
    
    func deleteGoal(id: Int) -> AnyPublisher<Void, Error> {
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

                let url = self.baseURL.appendingPathComponent("/api/v1/goals/\(id)")

                self.session.request(
                    url,
                    method: .delete,
                    headers: headers,
                    parameters: nil,
                    encoding: nil
                )
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        promise(.success(()))
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
