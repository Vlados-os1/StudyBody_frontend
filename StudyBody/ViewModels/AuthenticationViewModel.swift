//
// AuthenticationViewModel.swift
// StudyBody
//

import Foundation
import SwiftUI

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var authenticationState: AuthenticationState = .checking
    @Published var showingLogin = true
    
    private let authService = AuthService.shared
    private let tokenManager = TokenManager.shared
    
    enum AuthenticationState {
        case checking
        case authenticated
        case unauthenticated
    }
    
    init() {
        checkAuthenticationStatus()
        
        Task {
            for await isAuthenticated in tokenManager.$isAuthenticated.values {
                updateAuthenticationState(isAuthenticated: isAuthenticated)
            }
        }
    }
    
    private func checkAuthenticationStatus() {
        if tokenManager.isAuthenticated {
            authenticationState = .authenticated
        } else {
            authenticationState = .unauthenticated
        }
    }
    
    private func updateAuthenticationState(isAuthenticated: Bool) {
        authenticationState = isAuthenticated ? .authenticated : .unauthenticated
    }
    
    func switchToLogin() {
        showingLogin = true
    }
    
    func switchToRegister() {
        showingLogin = false
    }
}
