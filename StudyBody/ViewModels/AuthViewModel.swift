//
//  AuthViewModel.swift
//  StudyBodyApp
//
//  Created by User on 25/08/2025.
//

import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    private let authManager: AuthManager
    
    init(authManager: AuthManager) {
        self.authManager = authManager
    }
    
    // MARK: - Registration
    func register(
        email: String,
        fullName: String,
        password: String,
        confirmPassword: String,
        department: UserDepartment?,
        interests: String?
    ) async {
        clearMessages()
        
        guard !email.isEmpty, !fullName.isEmpty, !password.isEmpty else {
            errorMessage = "Заполните все обязательные поля"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Пароли не совпадают"
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "Пароль должен содержать минимум 6 символов"
            return
        }
        
        isLoading = true
        
        let result = await authManager.register(
            email: email,
            fullName: fullName,
            password: password,
            confirmPassword: confirmPassword,
            department: department,
            interests: interests
        )
        
        isLoading = false
        
        switch result {
        case .success(let message):
            successMessage = message
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Login
    func login(email: String, password: String) async {
        clearMessages()
        
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Заполните все поля"
            return
        }
        
        isLoading = true
        
        let result = await authManager.login(email: email, password: password)
        
        isLoading = false
        
        switch result {
        case .success:
            // Success handled by AuthManager
            break
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Forgot Password
    func forgotPassword(email: String) async {
        clearMessages()
        
        guard !email.isEmpty else {
            errorMessage = "Введите email"
            return
        }
        
        isLoading = true
        
        let result = await authManager.forgotPassword(email: email)
        
        isLoading = false
        
        switch result {
        case .success(let message):
            successMessage = message
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Reset Password
    func resetPassword(token: String, password: String, confirmPassword: String) async {
        clearMessages()
        
        guard !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Заполните все поля"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Пароли не совпадают"
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "Пароль должен содержать минимум 6 символов"
            return
        }
        
        isLoading = true
        
        let result = await authManager.resetPassword(
            token: token,
            password: password,
            confirmPassword: confirmPassword
        )
        
        isLoading = false
        
        switch result {
        case .success(let message):
            successMessage = message
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Logout
    func logout() async {
        isLoading = true
        await authManager.logout()
        isLoading = false
    }
    
    // MARK: - Utility
    private func clearMessages() {
        errorMessage = nil
        successMessage = nil
    }
    
    func clearAllMessages() {
        clearMessages()
    }
}
