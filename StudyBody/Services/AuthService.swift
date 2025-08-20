//
// AuthService.swift
// StudyBody
//

import Foundation
import SwiftUI

@MainActor
final class AuthService: ObservableObject {
    static let shared = AuthService()
    
    private let networkService = NetworkService.shared
    private let tokenManager = TokenManager.shared
    
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private init() {
        Task {
            for await isAuthenticated in tokenManager.$isAuthenticated.values {
                if isAuthenticated {
                    await fetchCurrentUser()
                } else {
                    currentUser = nil
                }
            }
        }
    }
    
    // MARK: - Authentication Methods
    
    func login(email: String, password: String) async throws {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        let request = LoginRequest(email: email, password: password)
        
        do {
            let response: LoginResponse = try await networkService.post(
                endpoint: "/api/login",
                body: request,
                responseType: LoginResponse.self
            )
            
            tokenManager.saveAccessToken(response.token)
            await fetchCurrentUser()
        } catch let error as AuthError {
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    func register(
        name: String,
        email: String,
        password: String,
        confirmPassword: String,
        department: UserDepartment?,
        interests: String
    ) async throws {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        let request = UserRegister(
            fullName: name,
            email: email,
            password: password,
            confirmPassword: confirmPassword,
            department: department,
            interests: interests.isEmpty ? nil : interests
        )
        
        do {
            let _: User = try await networkService.post(
                endpoint: "/api/register",
                body: request,
                responseType: User.self
            )
            // После регистрации пользователь должен подтвердить email
        } catch let error as AuthError {
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    func forgotPassword(email: String) async throws {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        let request = ForgotPasswordRequest(email: email)
        
        do {
            let _: SuccessResponse = try await networkService.post(
                endpoint: "/api/forgot-password",
                body: request,
                responseType: SuccessResponse.self
            )
        } catch let error as AuthError {
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    func logout() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let _: SuccessResponse = try await networkService.post(
                endpoint: "/api/logout",
                body: EmptyRequest(),
                requiresAuth: true,
                responseType: SuccessResponse.self
            )
        } catch {
            print("Logout error: \(error)")
        }
        
        await tokenManager.clearTokens()
        currentUser = nil
    }
    
    // MARK: - User Profile Methods
    
    func fetchCurrentUser() async {
        do {
            let userData: UserProfileResponse = try await networkService.get(
                endpoint: "/api/main",
                requiresAuth: true,
                responseType: UserProfileResponse.self
            )
            
            currentUser = User(
                id: UUID(), // Backend не возвращает ID в /api/main
                email: userData.email,
                fullName: userData.fullName,
                department: userData.department,
                interests: userData.interests
            )
        } catch {
            if let authError = error as? AuthError {
                switch authError.type {
                case .tokenExpired:
                    await tokenManager.clearTokens()
                default:
                    break
                }
            }
        }
    }
    
    func updateProfile(_ facts: UserStudentFacts) async throws {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let _: SuccessResponse = try await networkService.patch(
                endpoint: "/api/main/update",
                body: facts,
                responseType: SuccessResponse.self
            )
            
            if var user = currentUser {
                user.department = facts.department
                user.interests = facts.interests
                currentUser = user
            }
        } catch let error as AuthError {
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    // MARK: - Helper Methods
    
    func clearError() {
        errorMessage = nil
    }
    
    var isAuthenticated: Bool {
        tokenManager.isAuthenticated
    }
}

// Схема ответа от /api/main
struct UserProfileResponse: Codable {
    let email: String
    let fullName: String
    let department: UserDepartment?
    let interests: String?
    
    enum CodingKeys: String, CodingKey {
        case email, department, interests
        case fullName = "full_name"
    }
}

struct EmptyRequest: Codable {}
