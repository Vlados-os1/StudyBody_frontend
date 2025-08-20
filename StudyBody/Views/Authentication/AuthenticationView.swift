//
// AuthenticationView.swift
// StudyBody
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    
    var body: some View {
        Group {
            switch viewModel.authenticationState {
            case .checking:
                ProgressView("Проверка аутентификации...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
            case .authenticated:
                RootTabView()
            case .unauthenticated:
                if viewModel.showingLogin {
                    LoginView(
                        onSwitchToRegister: viewModel.switchToRegister,
                        onLoginSuccess: viewModel.switchToLogin
                    )
                } else {
                    RegisterView(
                        onSwitchToLogin: viewModel.switchToLogin,
                        onRegisterSuccess: viewModel.switchToLogin
                    )
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.authenticationState)
        .animation(.easeInOut(duration: 0.3), value: viewModel.showingLogin)
    }
}
