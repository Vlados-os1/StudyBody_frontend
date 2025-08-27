//
// NetworkManager.swift
// StudyBodyApp
//
// Created by User on 25/08/2025.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = Constants.API.baseURL
    private let session = URLSession.shared
    
    private init() {}

    // MARK: - Generic Request Method
    private func performRequest<T: Codable>(
        url: URL,
        method: HTTPMethod,
        body: Data? = nil,
        headers: [String: String] = [:],
        responseType: T.Type
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        // Default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add custom headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200...299 ~= httpResponse.statusCode else {
            // Try to decode error response
            if let errorData = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw NetworkError.serverError(errorData.message)
            }
            throw NetworkError.serverError("HTTP \(httpResponse.statusCode)")
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError(error)
        }
    }

    // MARK: - Auth Methods
    func register(request: UserRegisterRequest) async throws -> User {
        guard let url = URL(string: "\(baseURL)/api/register") else {
            throw NetworkError.invalidURL
        }

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let body = try encoder.encode(request)

        return try await performRequest(
            url: url,
            method: .POST,
            body: body,
            responseType: User.self
        )
    }

    func login(request: UserLoginRequest) async throws -> LoginResponse {
        guard let url = URL(string: "\(baseURL)/api/login") else {
            throw NetworkError.invalidURL
        }

        let encoder = JSONEncoder()
        let body = try encoder.encode(request)

        return try await performRequest(
            url: url,
            method: .POST,
            body: body,
            responseType: LoginResponse.self
        )
    }

    func refreshToken() async throws -> TokenResponse {
        guard let url = URL(string: "\(baseURL)/api/refresh") else {
            throw NetworkError.invalidURL
        }

        return try await performRequest(
            url: url,
            method: .POST,
            responseType: TokenResponse.self
        )
    }

    func logout(token: String) async throws -> SuccessResponse {
        guard let url = URL(string: "\(baseURL)/api/logout") else {
            throw NetworkError.invalidURL
        }

        let headers = ["Authorization": "Bearer \(token)"]

        return try await performRequest(
            url: url,
            method: .POST,
            headers: headers,
            responseType: SuccessResponse.self
        )
    }

    func forgotPassword(request: ForgotPasswordRequest) async throws -> SuccessResponse {
        guard let url = URL(string: "\(baseURL)/api/forgot-password") else {
            throw NetworkError.invalidURL
        }

        let encoder = JSONEncoder()
        let body = try encoder.encode(request)

        return try await performRequest(
            url: url,
            method: .POST,
            body: body,
            responseType: SuccessResponse.self
        )
    }

    func resetPassword(token: String, request: PasswordResetRequest) async throws -> SuccessResponse {
        guard let url = URL(string: "\(baseURL)/api/password-reset?token=\(token)") else {
            throw NetworkError.invalidURL
        }

        let encoder = JSONEncoder()
        let body = try encoder.encode(request)

        return try await performRequest(
            url: url,
            method: .POST,
            body: body,
            responseType: SuccessResponse.self
        )
    }

    func updatePassword(token: String, request: PasswordUpdateRequest) async throws -> SuccessResponse {
        guard let url = URL(string: "\(baseURL)/api/password-update") else {
            throw NetworkError.invalidURL
        }

        let encoder = JSONEncoder()
        let body = try encoder.encode(request)
        let headers = ["Authorization": "Bearer \(token)"]

        return try await performRequest(
            url: url,
            method: .POST,
            body: body,
            headers: headers,
            responseType: SuccessResponse.self
        )
    }

    // MARK: - User Methods
    func getCurrentUser(token: String) async throws -> User {
        guard let url = URL(string: "\(baseURL)/api/main") else {
            throw NetworkError.invalidURL
        }

        let headers = ["Authorization": "Bearer \(token)"]

        return try await performRequest(
            url: url,
            method: .GET,
            headers: headers,
            responseType: User.self
        )
    }

    func updateProfile(token: String, request: UserUpdateRequest) async throws -> SuccessResponse {
        guard let url = URL(string: "\(baseURL)/api/main/update") else {
            throw NetworkError.invalidURL
        }

        let encoder = JSONEncoder()
        let body = try encoder.encode(request)
        let headers = ["Authorization": "Bearer \(token)"]

        return try await performRequest(
            url: url,
            method: .PATCH,
            body: body,
            headers: headers,
            responseType: SuccessResponse.self
        )
    }

    // MARK: - Vacancy Methods
    func getAllVacancies(token: String) async throws -> [Vacancy] {
        guard let url = URL(string: "\(baseURL)/api/vacancies") else {
            throw NetworkError.invalidURL
        }

        let headers = ["Authorization": "Bearer \(token)"]

        return try await performRequest(
            url: url,
            method: .GET,
            headers: headers,
            responseType: [Vacancy].self
        )
    }

    func getMyVacancies(token: String) async throws -> [Vacancy] {
        guard let url = URL(string: "\(baseURL)/api/main/vacancies") else {
            throw NetworkError.invalidURL
        }

        let headers = ["Authorization": "Bearer \(token)"]

        return try await performRequest(
            url: url,
            method: .GET,
            headers: headers,
            responseType: [Vacancy].self
        )
    }

    func getVacancy(token: String, id: String) async throws -> Vacancy {
        guard let url = URL(string: "\(baseURL)/api/vacancy?vacancy_id=\(id)") else {
            throw NetworkError.invalidURL
        }

        let headers = ["Authorization": "Bearer \(token)"]

        return try await performRequest(
            url: url,
            method: .GET,
            headers: headers,
            responseType: Vacancy.self
        )
    }

    func createVacancy(token: String, request: CreateVacancyRequest) async throws -> Vacancy {
        guard let url = URL(string: "\(baseURL)/api/main/create_vacancy") else {
            throw NetworkError.invalidURL
        }

        let encoder = JSONEncoder()
        let body = try encoder.encode(request)
        let headers = ["Authorization": "Bearer \(token)"]

        return try await performRequest(
            url: url,
            method: .POST,
            body: body,
            headers: headers,
            responseType: Vacancy.self
        )
    }

    func updateVacancy(token: String, id: String, request: UpdateVacancyRequest) async throws -> SuccessResponse {
        guard let url = URL(string: "\(baseURL)/api/main/update_vacancy/\(id)") else {
            throw NetworkError.invalidURL
        }

        let encoder = JSONEncoder()
        let body = try encoder.encode(request)
        let headers = ["Authorization": "Bearer \(token)"]

        return try await performRequest(
            url: url,
            method: .PATCH,
            body: body,
            headers: headers,
            responseType: SuccessResponse.self
        )
    }

    func deleteVacancy(token: String, id: String) async throws -> SuccessResponse {
        guard let url = URL(string: "\(baseURL)/api/delete_vacancy/\(id)") else {
            throw NetworkError.invalidURL
        }

        let headers = ["Authorization": "Bearer \(token)"]

        return try await performRequest(
            url: url,
            method: .DELETE,
            headers: headers,
            responseType: SuccessResponse.self
        )
    }
}

// MARK: - HTTP Method Enum
extension NetworkManager {
    enum HTTPMethod: String {
        case GET = "GET"
        case POST = "POST"
        case PATCH = "PATCH"
        case DELETE = "DELETE"
    }
}

// MARK: - Network Error Enum
extension NetworkManager {
    enum NetworkError: Error, LocalizedError {
        case invalidURL
        case invalidResponse
        case serverError(String)
        case decodingError(Error)

        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Неверный URL"
            case .invalidResponse:
                return "Неверный ответ"
            case .serverError(let message):
                return message
            case .decodingError(let error):
                return "Ошибка обработки данных: \(error.localizedDescription)"
            }
        }
    }
}
