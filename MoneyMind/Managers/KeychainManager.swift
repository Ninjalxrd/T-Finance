//
//  KeychainManager.swift
//  MoneyMind
//
//  Created by Павел on 28.05.2025.
//

import Security
import Foundation

protocol KeychainManagerProtocol: Sendable {
    func saveAccessToken(_ token: String)
    func getAccessToken() -> String?
    func saveRefreshToken(_ token: String)
    func getRefreshToken() -> String?
}

final class KeychainManager: KeychainManagerProtocol {
    // MARK: - Properties
    
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let service = Bundle.main.bundleIdentifier ?? "com.moneymind.app"
    
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - Public Methods
    
    func saveAccessToken(_ token: String) {
        save(token, forKey: accessTokenKey)
    }
    
    func getAccessToken() -> String? {
        return load(forKey: accessTokenKey)
    }
    
    func saveRefreshToken(_ token: String) {
        save(token, forKey: refreshTokenKey)
    }
    
    func getRefreshToken() -> String? {
        return load(forKey: refreshTokenKey)
    }
    
    // MARK: - Private Methods
    
    private func save(_ value: String, forKey key: String) {
        let data = value.data(using: .utf8)!
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service as CFString,
            kSecAttrAccount: key as CFString,
            kSecValueData: data
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func load(forKey key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service as CFString,
            kSecAttrAccount: key as CFString,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
