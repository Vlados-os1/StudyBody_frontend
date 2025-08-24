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

    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }

    func login() async {
        guard isFormValid else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await AuthService.shared.login(email: email, password: password)
        } catch {
            errorMessage = AuthService.shared.errorMessage
        }
    }

    func clearError() {
        errorMessage = nil
    }
}
