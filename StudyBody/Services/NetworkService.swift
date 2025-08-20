//
// NetworkService.swift
// StudyBody
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    static let baseURL = "https://study-body.online:8080"
    
    private let tokenManager = TokenManager.shared
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpCookieAcceptPolicy = .always
        config.httpShouldSetCookies = true
        config.httpCookieStorage = HTTPCookieStorage.shared
        return URLSession(configuration: config)
    }()
    
    private init() {}
    
    // MARK: - Generic Request Method
    func request<T: Codable>(
        endpoint: String,
        method: HTTPMethod = .GET,
        body: Data? = nil,
        requiresAuth: Bool = false,
        responseType: T.Type
    ) async throws -> T {
        guard let url = URL(string: "\(Self.baseURL)\(endpoint)") else {
            throw AuthError.invalidURL()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if requiresAuth {
            let accessToken = try await tokenManager.getValidAccessToken()
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.networkError(URLError(.badServerResponse))
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                return try JSONDecoder().decode(T.self, from: data)
            case 400:
                if let errorResponse = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                    if errorResponse.detail.contains("already registered") {
                        throw AuthError.emailAlreadyExists()
                    }
                }
                throw AuthError.serverError(400)
            case 401:
                if requiresAuth {
                    await tokenManager.clearTokens()
                    throw AuthError.tokenExpired()
                }
                throw AuthError.invalidCredentials()
            case 404:
                throw AuthError.userNotFound()
            default:
                throw AuthError.serverError(httpResponse.statusCode)
            }
        } catch let error as AuthError {
            throw error
        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            throw AuthError.decodingError()
        } catch {
            throw AuthError.networkError(error)
        }
    }
    
    // Convenience Methods
    
    func get<T: Codable>(
        endpoint: String,
        requiresAuth: Bool = false,
        responseType: T.Type
    ) async throws -> T {
        return try await request(
            endpoint: endpoint,
            method: .GET,
            requiresAuth: requiresAuth,
            responseType: responseType
        )
    }
    
    func post<T: Codable, B: Codable>(
        endpoint: String,
        body: B,
        requiresAuth: Bool = false,
        responseType: T.Type
    ) async throws -> T {
        let bodyData = try JSONEncoder().encode(body)
        return try await request(
            endpoint: endpoint,
            method: .POST,
            body: bodyData,
            requiresAuth: requiresAuth,
            responseType: responseType
        )
    }
    
    func patch<T: Codable, B: Codable>(
        endpoint: String,
        body: B,
        requiresAuth: Bool = true,
        responseType: T.Type
    ) async throws -> T {
        let bodyData = try JSONEncoder().encode(body)
        return try await request(
            endpoint: endpoint,
            method: .PATCH,
            body: bodyData,
            requiresAuth: requiresAuth,
            responseType: responseType
        )
    }
    
    func delete(
        endpoint: String,
        requiresAuth: Bool = true
    ) async throws {
        let _: EmptyResponse = try await request(
            endpoint: endpoint,
            method: .DELETE,
            requiresAuth: requiresAuth,
            responseType: EmptyResponse.self
        )
    }
    
    enum HTTPMethod: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
        case PATCH = "PATCH"
    }
    
    struct ServerErrorResponse: Codable {
        let detail: String
    }
    
    struct EmptyResponse: Codable {}
}
