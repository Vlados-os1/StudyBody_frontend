//
// AuthError.swift
// StudyBody
//

import Foundation

struct AuthError: Error, LocalizedError {
    enum ErrorType {
        case invalidURL
        case invalidCredentials
        case tokenExpired
        case networkError(Error)
        case decodingError
        case serverError(Int)
        case userNotFound
        case emailAlreadyExists
        case unknown(Error)
    }

    let type: ErrorType
    
    var errorDescription: String? {
        switch type {
        case .invalidURL:
            return "Неправильный URL"
        case .invalidCredentials:
            return "Неверный email или пароль"
        case .tokenExpired:
            return "Сессия истекла. Войдите заново"
        case .networkError(let error):
            return "Ошибка сети: \(error.localizedDescription)"
        case .decodingError:
            return "Ошибка обработки данных"
        case .serverError(let code):
            return "Ошибка сервера: \(code)"
        case .userNotFound:
            return "Пользователь не найден"
        case .emailAlreadyExists:
            return "Email уже зарегистрирован"
        case .unknown(let error):
            return "Неизвестная ошибка: \(error.localizedDescription)"
        }
    }
    
    static func invalidURL() -> AuthError {
        AuthError(type: .invalidURL)
    }
    
    static func invalidCredentials() -> AuthError {
        AuthError(type: .invalidCredentials)
    }
    
    static func tokenExpired() -> AuthError {
        AuthError(type: .tokenExpired)
    }
    
    static func networkError(_ error: Error) -> AuthError {
        AuthError(type: .networkError(error))
    }
    
    static func decodingError() -> AuthError {
        AuthError(type: .decodingError)
    }
    
    static func serverError(_ code: Int) -> AuthError {
        AuthError(type: .serverError(code))
    }
    
    static func userNotFound() -> AuthError {
        AuthError(type: .userNotFound)
    }
    
    static func emailAlreadyExists() -> AuthError {
        AuthError(type: .emailAlreadyExists)
    }
    
    static func unknown(_ error: Error) -> AuthError {
        AuthError(type: .unknown(error))
    }
}
