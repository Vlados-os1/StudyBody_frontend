import Foundation

// MARK: - Регистрация пользователя
struct UserRegisterRequest: Codable {
    let email: String
    let fullName: String
    let department: String?
    let interests: String?
    let password: String
    let confirmPassword: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case fullName = "full_name"
        case department
        case interests
        case password
        case confirmPassword = "confirm_password"
    }
}

// MARK: - Вход пользователя
struct UserLoginRequest: Codable {
    let email: String
    let password: String
}

// MARK: - Обновление профиля пользователя
struct UserUpdateRequest: Codable {
    let department: String?
    let interests: String?
}

// MARK: - Создание вакансии
struct VacancyCreateRequest: Codable {
    let title: String
    let description: String?
    let tags: String?
}

// MARK: - Обновление вакансии
struct VacancyUpdateRequest: Codable {
    let title: String?
    let description: String?
    let tags: String?
}

// MARK: - Сброс пароля
struct ForgotPasswordRequest: Codable {
    let email: String
}

struct PasswordResetRequest: Codable {
    let password: String
    let confirmPassword: String
    
    enum CodingKeys: String, CodingKey {
        case password
        case confirmPassword = "confirm_password"
    }
}

struct PasswordUpdateRequest: Codable {
    let oldPassword: String
    let password: String
    let confirmPassword: String
    
    enum CodingKeys: String, CodingKey {
        case oldPassword = "old_password"
        case password
        case confirmPassword = "confirm_password"
    }
}

struct CreateVacancyRequest: Codable {
    let title: String
    let description: String?
    let tags: String?
}

struct UpdateVacancyRequest: Codable {
    let title: String?
    let description: String?
    let tags: String?
}
