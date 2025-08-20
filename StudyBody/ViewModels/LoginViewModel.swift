//
// LoginViewModel.swift
// StudyBody
//

import Foundation
import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingForgotPassword = false
    
    private let authService = AuthService.shared
    
    var isFormValid: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        email.contains("@") &&
        password.count >= 6
    }
    
    func login() async {
        guard isFormValid else {
            errorMessage = "Заполните все поля корректно"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await authService.login(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func clearForm() {
        email = ""
        password = ""
        errorMessage = nil
    }
    
    func clearError() {
        errorMessage = nil
    }
}
