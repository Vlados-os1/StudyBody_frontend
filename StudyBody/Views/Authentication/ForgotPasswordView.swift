//
//  ForgotPasswordView.swift
//  StudyBodyApp
//
//  Created by User on 25/08/2025.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var viewModel: AuthViewModel
    
    @State private var email: String = ""
    
    init() {
        let authManager = AuthManager()
        self._viewModel = StateObject(wrappedValue: AuthViewModel(authManager: authManager))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: Constants.UI.largeSpacing) {
                Spacer()
                
                // Header
                VStack(spacing: Constants.UI.mediumSpacing) {
                    Image(systemName: "key.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Constants.Colors.primaryBlue)
                    
                    Text("Восстановление пароля")
                        .font(Constants.Fonts.title1)
                        .foregroundColor(Constants.Colors.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Введите адрес электронной почты, на который мы отправим ссылку для восстановления пароля")
                        .font(Constants.Fonts.body)
                        .foregroundColor(Constants.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Constants.UI.padding)
                }
                
                // Form
                VStack(spacing: Constants.UI.mediumSpacing) {
                    CustomTextField(
                        placeholder: "Email",
                        text: $email,
                        icon: Constants.Images.envelope,
                        keyboardType: .emailAddress,
                        contentType: .emailAddress
                    )
                    
                    // Error/Success Messages
                    if let errorMessage = viewModel.errorMessage {
                        ErrorBannerView(
                            message: errorMessage,
                            isVisible: .constant(true)
                        )
                    }
                    
                    if let successMessage = viewModel.successMessage {
                        SuccessBannerView(
                            message: successMessage,
                            isVisible: .constant(true)
                        )
                    }
                    
                    // Send Button
                    Button {
                        Task {
                            await viewModel.forgotPassword(email: email)
                        }
                    } label: {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .tint(.white)
                            }
                            Text("Отправить ссылку")
                                .font(Constants.Fonts.headline)
                        }
                    }
                    .primaryButtonStyle()
                    .disabled(viewModel.isLoading || email.isEmpty || !email.isValidEmail)
                    .padding(.top, Constants.UI.smallSpacing)
                }
                .padding(.horizontal, Constants.UI.largePadding)
                
                Spacer()
                
                // Back to Login
                Button("Вернуться к входу") {
                    dismiss()
                }
                .font(Constants.Fonts.headline)
                .foregroundColor(Constants.Colors.primaryBlue)
                .padding(.bottom, Constants.UI.largePadding)
            }
            .navigationTitle("Восстановление")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                    .foregroundColor(Constants.Colors.primaryBlue)
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            viewModel.clearAllMessages()
        }
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(AuthManager())
}
