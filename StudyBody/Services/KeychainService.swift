//
// KeychainService.swift
// StudyBody
//

import Foundation
import Security

final class KeychainService {
    static let shared = KeychainService()
    private init() {}
    
    private let service = Bundle.main.bundleIdentifier ?? "com.studybody.app"
    
    enum KeychainKey: String, CaseIterable {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case userID = "user_id"
    }
    
    func save(_ value: String, forKey key: KeychainKey) -> Bool {
        let data = value.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func load(forKey key: KeychainKey) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        return value
    }
    
    func delete(forKey key: KeychainKey) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
    
    func deleteAll() {
        for key in KeychainKey.allCases {
            _ = delete(forKey: key)
        }
    }
}
