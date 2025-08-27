//
// Auth.swift
// StudyBodyApp
//

import Foundation

// MARK: - Login Response
struct LoginResponse: Codable {
    let token: String
}

// MARK: - Token Refresh Response
struct TokenRefreshResponse: Codable {
    let token: String
}

// MARK: - JWT Token Storage
struct TokenPair {
    let accessToken: String
    let refreshToken: String?
}

// MARK: - Auth State
enum AuthState {
    case loading
    case authenticated(User)
    case unauthenticated
}
