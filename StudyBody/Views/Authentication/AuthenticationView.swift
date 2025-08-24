import SwiftUI

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var showingVerificationNotice = false

    var body: some View {
        content
            .animation(.easeInOut(duration: 0.3), value: viewModel.authenticationState)
            .animation(.easeInOut(duration: 0.3), value: viewModel.showingLogin)
    }

    @ViewBuilder
    private var content: some View {
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
                    onLoginSuccess: {},
                    showingVerificationNotice: showingVerificationNotice,
                    onHideVerificationNotice: { showingVerificationNotice = false }
                )
            } else {
                RegisterView(
                    onSwitchToLogin: {
                        viewModel.switchToLogin()
                        showingVerificationNotice = true
                    },
                    onRegisterSuccess: {
                        viewModel.switchToLogin()
                        showingVerificationNotice = true
                    }
                )
            }
        }
    }
}
