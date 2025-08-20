//
// TokenManager.swift
// StudyBody
//

import Foundation

@MainActor
final class TokenManager: ObservableObject {
    static let shared = TokenManager()
    
    private let keychain = KeychainService.shared
    
    @Published private(set) var isAuthenticated = false
    
    private var accessToken: String?
    
    private init() {
        if let token = keychain.load(forKey: .accessToken) {
            self.accessToken = token
            self.isAuthenticated = true
        }
    }
    
    func saveAccessToken(_ token: String) {
        self.accessToken = token
        keychain.save(token, forKey: .accessToken)
        isAuthenticated = true
    }
    
    func getValidAccessToken() async throws -> String {
        if let token = accessToken {
            return token
        }
        return try await refreshAccessToken()
    }
    
    func refreshAccessToken() async throws -> String {
        guard let url = URL(string: "\(NetworkService.baseURL)/api/refresh") else {
            throw AuthError.invalidURL()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let config = URLSessionConfiguration.default
        config.httpCookieAcceptPolicy = .always
        config.httpShouldSetCookies = true
        config.httpCookieStorage = HTTPCookieStorage.shared
        
        let session = URLSession(configuration: config)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.networkError(URLError(.badServerResponse))
            }
            
            if httpResponse.statusCode == 200 {
                let tokenResponse = try JSONDecoder().decode(RefreshResponse.self, from: data)
                saveAccessToken(tokenResponse.token)
                return tokenResponse.token
            } else {
                throw AuthError.tokenExpired()
            }
        } catch {
            await clearTokens()
            throw AuthError.tokenExpired()
        }
    }
    
    func clearTokens() async {
        accessToken = nil
        keychain.deleteAll()
        isAuthenticated = false
    }
}

struct RefreshResponse: Codable {
    let token: String
}
