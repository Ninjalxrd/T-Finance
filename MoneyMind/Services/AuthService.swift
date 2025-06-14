//
//  AuthService.swift
//  MoneyMind
//
//  Created by Павел on 21.05.2025.
//

import Alamofire
import Combine
import Foundation

struct AuthResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let message: String?
}

protocol AuthServiceProtocol {
    func sendSMS(phoneNumber: String) -> AnyPublisher<Void, Error>
    func confirmSMS(phoneNumber: String, code: String) -> AnyPublisher<AuthResponse, Error>
}

final class AuthService: AuthServiceProtocol {
    private let session: NetworkSessionProtocol
    private let tokenManager: TokenManagerProtocol
    private let baseURL = "https://t-bank-finance.ru/api/v1/auth"
    
    init(session: NetworkSessionProtocol, tokenManager: TokenManagerProtocol) {
        self.session = session
        self.tokenManager = tokenManager
    }
    
    func sendSMS(phoneNumber: String) -> AnyPublisher<Void, Error> {
        let formattedNumber = formatPhoneNumber(phoneNumber)
        let parameters = ["phoneNumber": formattedNumber]
        return session.request(
            "\(baseURL)/send-sms",
            method: .post,
            headers: nil,
            parameters: parameters,
            encoding: JSONEncoding.default
        )
        .validate()
        .publishData()
        .tryMap { dataResponse in
            _ = try dataResponse.result.get()
            return ()
        }
        .eraseToAnyPublisher()
    }
    
    func confirmSMS(phoneNumber: String, code: String) -> AnyPublisher<AuthResponse, Error> {
        let formattedNumber = formatPhoneNumber(phoneNumber)
        let parameters = ["phoneNumber": formattedNumber, "code": code]
        return session.request(
            "\(baseURL)/confirm-sms",
            method: .post,
            headers: nil,
            parameters: parameters,
            encoding: JSONEncoding.default
        )
        .publishData()
        .tryMap { res -> Data in
            switch res.result {
            case .success(let data):
                return data
            case .failure(let err):
                throw err
            }
        }
        .decode(type: AuthResponse.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
}

extension AuthService {
    func formatPhoneNumber(_ input: String) -> String {
        let digits = input.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return "+" + digits
    }
}
