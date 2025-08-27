import Foundation

struct UserResponse: Codable {
    let id: String
    let email: String
    let fullName: String
    let department: String?
    let interests: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case fullName = "full_name"
        case department
        case interests
    }
}

struct VacancyResponse: Codable {
    let id: String
    let title: String
    let description: String?
    let tags: String?
    let createdAt: String?
    let updatedAt: String?
    let user: UserResponse
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case tags
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user
    }
}

struct SuccessResponse: Codable {
    let msg: String
}

struct TokenResponse: Codable {
    let token: String
}

struct ErrorResponse: Codable {
    let message: String
    let errorCode: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case errorCode = "error_code"
    }
}
