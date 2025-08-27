//
//  APIResponse.swift
//  StudyBodyApp
//
//  Created by User on 25/08/2025.
//

import Foundation

// MARK: - API Error
enum APIError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    case serverError(String)
    case unauthorized
    case forbidden
    case notFound
    case validationError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный URL"
        case .noData:
            return "Нет данных"
        case .decodingError:
            return "Ошибка обработки данных"
        case .networkError(let error):
            return "Ошибка сети: \(error.localizedDescription)"
        case .serverError(let message):
            return message
        case .unauthorized:
            return "Не авторизован"
        case .forbidden:
            return "Доступ запрещен"
        case .notFound:
            return "Не найдено"
        case .validationError(let message):
            return "Ошибка валидации: \(message)"
        }
    }
}

// MARK: - API Result
typealias APIResult<T> = Result<T, APIError>
