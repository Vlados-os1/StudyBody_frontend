//
// RegisterViewModel.swift
// StudyBody
//

import Foundation
import SwiftUI

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var department: UserDepartment? = nil
    @Published var interests = ""
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let authService = AuthService.shared
    
    var isFormValid: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        email.contains("@") &&
        password.count >= 8 &&
        password == confirmPassword
    }
    
    var passwordValidationMessage: String? {
        if password.isEmpty { return nil }
        if password.count < 8 { return "Пароль должен содержать минимум 8 символов" }
        return nil
    }
    
    var confirmPasswordValidationMessage: String? {
        if confirmPassword.isEmpty { return nil }
        if password != confirmPassword { return "Пароли не совпадают" }
        return nil
    }
    
    func register() async {
        guard isFormValid else {
            errorMessage = "Заполните все поля корректно"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await authService.register(
                name: name,
                email: email,
                password: password,
                confirmPassword: confirmPassword,
                department: department,
                interests: interests
            )
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func clearForm() {
        name = ""
        email = ""
        password = ""
        confirmPassword = ""
        department = nil
        interests = ""
        errorMessage = nil
    }
    
    func clearError() {
        errorMessage = nil
    }
}
