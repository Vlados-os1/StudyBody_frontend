//
// ForgotPasswordViewModel.swift
// StudyBody
//

import Foundation
import SwiftUI

@MainActor
final class ForgotPasswordViewModel: ObservableObject {
    @Published var email = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var isEmailSent = false
    
    private let authService = AuthService.shared
    
    var isFormValid: Bool {
        !email.isEmpty && email.contains("@")
    }
    
    func sendResetEmail() async {
        guard isFormValid else {
            errorMessage = "Введите корректный email"
            return
        }
        
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        do {
            try await authService.forgotPassword(email: email)
            successMessage = "Инструкции по восстановлению пароля отправлены на ваш email"
            isEmailSent = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func resetForm() {
        email = ""
        errorMessage = nil
        successMessage = nil
        isEmailSent = false
    }
    
    func clearError() {
        errorMessage = nil
    }
}
