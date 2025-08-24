import Foundation

enum NetworkError: Error {
    case noInternetConnection
    case timeout
    case serverUnavailable
    case decodingFailed
    case httpError(Int, Data?)
}

struct APIError: Codable {
    let message: String
    let error_code: String?
    
    enum CodingKeys: String, CodingKey {
        case message
        case error_code
    }
}

struct ErrorHandler {
    static func getUserFriendlyMessage(from error: Error) -> String {
        logError(error)
        
        if let networkError = error as? NetworkError {
            return handleNetworkError(networkError)
        }
        
        if let httpError = error as? HTTPError {
            return handleHTTPError(httpError)
        }
        
        return "Произошла неизвестная ошибка. Попробуйте позже."
    }
    
    private static func logError(_ error: Error) {
        print("Technical error: \(error)")
        if let httpError = error as? HTTPError,
           let data = httpError.data,
           let errorString = String(data: data, encoding: .utf8) {
            print("HTTP Error details: \(errorString)")
        }
    }
    
    private static func handleNetworkError(_ error: NetworkError) -> String {
        switch error {
        case .noInternetConnection:
            return "Отсутствует подключение к интернету"
        case .timeout:
            return "Время ожидания истекло. Проверьте подключение"
        case .serverUnavailable:
            return "Сервер временно недоступен"
        case .decodingFailed:
            return "Ошибка обработки данных от сервера"
        case .httpError(let statusCode, let data):
            return handleHTTPStatusCode(statusCode, data: data)
        }
    }
    
    private static func handleHTTPError(_ error: HTTPError) -> String {
        return handleHTTPStatusCode(error.statusCode, data: error.data)
    }
    
    private static func handleHTTPStatusCode(_ statusCode: Int, data: Data?) -> String {
        if let data = data,
           let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
            if let russianMessage = translateErrorCode(apiError.error_code) {
                return russianMessage
            }
            return apiError.message // fallback
        }
        
        switch statusCode {
        case 400:
            return "Неверные данные в запросе"
        case 401:
            return "Неверные данные для входа"
        case 403:
            return "Доступ запрещён"
        case 404:
            return "Ресурс не найден"
        case 409:
            return "Конфликт данных"
        case 422:
            return "Ошибка валидации данных"
        case 500:
            return "Внутренняя ошибка сервера"
        case 502, 503, 504:
            return "Сервер временно недоступен"
        default:
            return "Произошла ошибка (\(statusCode))"
        }
    }
    
    private static func translateErrorCode(_ errorCode: String?) -> String? {
        guard let code = errorCode else { return nil }
        let translations: [String: String] = [
            "AUTHENTICATION_ERROR": "Неверный email или пароль",
            "USER_NOT_FOUND": "Пользователь не найден",
            "USER_ALREADY_EXISTS": "Пользователь с таким email уже зарегистрирован",
            "ACCOUNT_NOT_ACTIVE": "Аккаунт не активирован. Проверьте почту для подтверждения",
            "TOKEN_EXPIRED": "Сессия истекла. Войдите заново",
            "INVALID_TOKEN": "Недействительный токен",
            "VALIDATION_ERROR": "Проверьте правильность введённых данных",
            "WEAK_PASSWORD": "Пароль должен содержать минимум 8 символов",
            "EMAIL_SEND_ERROR": "Ошибка отправки письма. Попробуйте позже",
            "NETWORK_ERROR": "Ошибка сети. Проверьте подключение",
            "SERVER_ERROR": "Ошибка сервера. Попробуйте позже",
            "UNKNOWN_ERROR": "Произошла неизвестная ошибка"
        ]
        
        return translations[code]
    }
}
