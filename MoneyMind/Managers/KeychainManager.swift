//
//  KeychainManager.swift
//  MoneyMind
//
//  Created by Павел on 21.05.2025.
//

import Security
import Foundation

final class KeychainManager {
    static let shared = KeychainManager()
    
    private init() {}
    
    func saveAccessToken(_ token: String) {
        save(token, forKey: "accessToken")
    }
    
    func getAccessToken() -> String? {
        return load(forKey: "accessToken")
    }
    
    func saveRefreshToken(_ token: String) {
        save(token, forKey: "refreshToken")
    }
    
    func getRefreshToken() -> String? {
        return load(forKey: "refreshToken")
    }
    
    private func save(_ value: String, forKey key: String) {
        let data = value.data(using: .utf8)!
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func load(forKey key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
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
