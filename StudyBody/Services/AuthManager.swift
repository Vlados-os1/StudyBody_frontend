//
// AuthManager.swift
// StudyBodyApp
//
// Created by User on 26/08/2025.
//

import Foundation
import SwiftUI

@MainActor
class AuthManager: ObservableObject {
    @Published var isLoggedIn = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkManager = NetworkManager.shared
    private let keychain = KeychainManager.shared
    
    init() {
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        isLoading = true
        if let token = keychain.getToken() {
            Task {
                do {
                    let user = try await networkManager.getCurrentUser(token: token)
                    await MainActor.run {
                        self.currentUser = user
                        self.isLoggedIn = true
                        self.isLoading = false
                    }
                } catch {
                    await MainActor.run {
                        self.logout()
                    }
                }
            }
        } else {
            isLoading = false
            isLoggedIn = false
        }
    }
    
    func login(email: String, password: String) async -> Result<Void, Error> {
        isLoading = true
        errorMessage = nil
        
        do {
            let request = UserLoginRequest(email: email, password: password)
            let response = try await networkManager.login(request: request)
            keychain.saveToken(response.token)
            
            let user = try await networkManager.getCurrentUser(token: response.token)
            self.currentUser = user
            self.isLoggedIn = true
            self.isLoading = false
            return .success(())
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            return .failure(error)
        }
    }
    
    func register(
        email: String,
        fullName: String,
        password: String,
        confirmPassword: String,
        department: UserDepartment?,
        interests: String?
    ) async -> Result<String, Error> {
        isLoading = true
        errorMessage = nil
        
        do {
            let departmentValue = department?.rawValue
            let request = UserRegisterRequest(
                email: email,
                fullName: fullName,
                department: departmentValue,
                interests: interests,
                password: password,
                confirmPassword: confirmPassword
            )
            
            let _ = try await networkManager.register(request: request)
            self.isLoading = false
            return .success("Проверьте почту для подтверждения аккаунта")
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            return .failure(error)
        }
    }
    
    // ИСПРАВЛЕННЫЙ МЕТОД LOGOUT
    func logout() {
        // Сразу обновляем состояние на главном потоке
        self.isLoggedIn = false
        self.currentUser = nil
        self.errorMessage = nil
        self.isLoading = false
        
        // Удаляем токен из keychain
        let token = keychain.getToken()
        keychain.deleteToken()
        
        // Асинхронно уведомляем сервер о выходе (но не ждем результата)
        if let token = token {
            Task {
                try? await networkManager.logout(token: token)
            }
        }
    }
    
    func updateProfile(department: UserDepartment?, interests: String?) async -> Result<String, Error> {
        guard let token = keychain.getToken() else {
            return .failure(NSError(domain: "AuthManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "Не авторизован"]))
        }
        
        isLoading = true
        do {
            let departmentValue = department?.rawValue
            let request = UserUpdateRequest(department: departmentValue, interests: interests)
            let _ = try await networkManager.updateProfile(token: token, request: request)
            
            let updatedUser = try await networkManager.getCurrentUser(token: token)
            self.currentUser = updatedUser
            
            isLoading = false
            return .success("Профиль обновлен")
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            return .failure(error)
        }
    }
    
    func forgotPassword(email: String) async -> Result<String, Error> {
        do {
            let request = ForgotPasswordRequest(email: email)
            let response = try await networkManager.forgotPassword(request: request)
            return .success(response.msg)
        } catch {
            return .failure(error)
        }
    }
    
    func resetPassword(token: String, password: String, confirmPassword: String) async -> Result<String, Error> {
        do {
            let request = PasswordResetRequest(password: password, confirmPassword: confirmPassword)
            let response = try await networkManager.resetPassword(token: token, request: request)
            return .success(response.msg)
        } catch {
            return .failure(error)
        }
    }
    
    func updatePassword(oldPassword: String, newPassword: String, confirmPassword: String) async -> Result<String, Error> {
        guard let token = keychain.getToken() else {
            return .failure(NSError(domain: "AuthManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "Не авторизован"]))
        }
        
        do {
            let request = PasswordUpdateRequest(
                oldPassword: oldPassword,
                password: newPassword,
                confirmPassword: confirmPassword
            )
            let response = try await networkManager.updatePassword(token: token, request: request)
            return .success(response.msg)
        } catch {
            return .failure(error)
        }
    }
    
    func loadUserProfile() async {
        guard let token = keychain.getToken() else { return }
        
        do {
            let user = try await networkManager.getCurrentUser(token: token)
            self.currentUser = user
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
