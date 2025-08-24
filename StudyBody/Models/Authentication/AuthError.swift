import Foundation

enum AuthError: Error, LocalizedError, Equatable {
    case invalidURL
    case invalidCredentials
    case tokenExpired
    case networkError(Error)
    case decodingError
    case serverError(Int)
    case userNotFound
    case emailAlreadyExists
    case unknown(Error)

    var errorDescription: String? {
        switch self {
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
            return "Пользователь с таким email уже зарегистрирован"
        case .unknown(let error):
            return "Неизвестная ошибка: \(error.localizedDescription)"
        }
    }

    static func == (lhs: AuthError, rhs: AuthError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.invalidCredentials, .invalidCredentials),
             (.tokenExpired, .tokenExpired),
             (.decodingError, .decodingError),
             (.userNotFound, .userNotFound),
             (.emailAlreadyExists, .emailAlreadyExists):
            return true
        case (.serverError(let lhsCode), .serverError(let rhsCode)):
            return lhsCode == rhsCode
        case (.networkError, .networkError),
             (.unknown, .unknown):
            return false
        default:
            return false
        }
    }
}
