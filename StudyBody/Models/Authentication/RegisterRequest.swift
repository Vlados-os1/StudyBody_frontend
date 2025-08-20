//
// RegisterRequest.swift
// StudyBody
//

import Foundation

struct UserRegister: Codable {
    let fullName: String
    let email: String
    let password: String
    let confirmPassword: String
    let department: UserDepartment?
    let interests: String?
    
    enum CodingKeys: String, CodingKey {
        case email, password, department, interests
        case fullName = "full_name"
        case confirmPassword = "confirm_password"
    }
}

struct RegisterResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let user: User
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case user
        case expiresIn = "expires_in"
    }
}

struct UserStudentFacts: Codable {
    let department: UserDepartment?
    let interests: String?
}
