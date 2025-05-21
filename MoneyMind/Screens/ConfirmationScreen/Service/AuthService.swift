//
//  AuthService.swift
//  MoneyMind
//
//  Created by Павел on 21.05.2025.
//

import Alamofire

struct AuthResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
}

final class AuthService {
    // MARK: - Property
    
    private let baseURL = "https://t-bank-finance.ru/api/v1/auth"
    
    // MARK: - Public Methods
    func sendSMS(phoneNumber: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let parameters = ["phoneNumber": phoneNumber]
        
        AF.request(
            "\(baseURL)/send-sms",
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default
        ).validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func confirmSMS(phoneNumber: String, code: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        let parameters = [
            "phoneNumber": phoneNumber,
            "code": code
        ]
        
        AF.request("\(baseURL)/confirm-sms",
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default
        ).validate(statusCode: 200..<300)
            .responseDecodable(of: AuthResponse.self) { response in
                switch response.result {
                case .success(let authResponse):
                    completion(.success(authResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
