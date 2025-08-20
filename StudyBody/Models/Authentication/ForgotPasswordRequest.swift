//
// ForgotPasswordRequest.swift
// StudyBody
//

import Foundation

struct ForgotPasswordRequest: Codable {
    let email: String
}

struct ForgotPasswordResponse: Codable {
    let message: String
}

struct SuccessResponse: Codable {
    let msg: String
}

struct ResetPasswordRequest: Codable {
    let email: String
    let resetToken: String
    let newPassword: String
    let confirmPassword: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case resetToken = "reset_token"
        case newPassword = "new_password"
        case confirmPassword = "confirm_password"
    }
}
