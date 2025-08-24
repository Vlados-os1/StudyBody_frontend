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
    @Published var department: UserDepartment?
    @Published var interests = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    var passwordValidationMessage: String? {
        guard !password.isEmpty else { return nil }
        if password.count < 8 {
            return "Пароль должен содержать минимум 8 символов"
        }
        return nil
    }

    var confirmPasswordValidationMessage: String? {
        guard !confirmPassword.isEmpty else { return nil }
        if password != confirmPassword {
            return "Пароли не совпадают"
        }
        return nil
    }

    var isFormValid: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        password.count >= 8 &&
        password == confirmPassword
    }

    func register() async {
        guard isFormValid else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await AuthService.shared.register(
                name: name,
                email: email,
                password: password,
                confirmPassword: confirmPassword,
                department: department,
                interests: interests
            )
        } catch {
            errorMessage = AuthService.shared.errorMessage
        }
    }

    func clearError() {
        errorMessage = nil
    }
}
