//
// ProfileViewModel.swift
// StudyBodyApp
//
// Created by User on 25/08/2025.
//

import Foundation
import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    private let authManager: AuthManager
    
    init(authManager: AuthManager) {
        self.authManager = authManager
    }

    // MARK: - Update Profile
    func updateProfile(department: UserDepartment?, interests: String?) async {
        clearMessages()
        isLoading = true
        
        let result = await authManager.updateProfile(department: department, interests: interests)
        
        isLoading = false
        
        switch result {
        case .success(let message):
            successMessage = message
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Change Password
    func changePassword(oldPassword: String, newPassword: String, confirmPassword: String) async {
        clearMessages()
        
        guard !oldPassword.isEmpty, !newPassword.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Заполните все поля"
            return
        }

        guard newPassword == confirmPassword else {
            errorMessage = "Новые пароли не совпадают"
            return
        }

        guard newPassword.count >= 6 else {
            errorMessage = "Пароль должен содержать минимум 6 символов"
            return
        }

        isLoading = true
        let result = await authManager.updatePassword(
            oldPassword: oldPassword,
            newPassword: newPassword,
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

    // MARK: - Logout - УПРОЩЕННЫЙ
    func logout() {
        // Просто вызываем logout без async - он теперь синхронный
        authManager.logout()
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
