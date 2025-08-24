//
// UserViewModel.swift
// StudyBody
//

import Foundation
import SwiftUI

@MainActor
final class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let authService = AuthService.shared

    func fetchProfile() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            await authService.fetchCurrentUser()
            self.user = authService.currentUser
        } catch {
            self.errorMessage = authService.errorMessage
        }
    }

    func saveProfile(_ updatedUser: User) async -> Bool {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let updateData = UserStudentFacts(
            department: updatedUser.department,
            interests: updatedUser.interests
        )

        do {
            try await authService.updateProfile(updateData)
            self.user = authService.currentUser
            return true
        } catch {
            self.errorMessage = authService.errorMessage
            return false
        }
    }

    func clearError() {
        errorMessage = nil
    }
}
