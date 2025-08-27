//
//  ResetPasswordView.swift
//  StudyBodyApp
//
//  Created by User on 25/08/2025.
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var viewModel: AuthViewModel
    
    let resetToken: String
    
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showingSuccessAlert = false
    
    init(resetToken: String) {
        self.resetToken = resetToken
        let authManager = AuthManager()
        self._viewModel = StateObject(wrappedValue: AuthViewModel(authManager: authManager))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: Constants.UI.largeSpacing) {
                Spacer()
                
                // Header
                VStack(spacing: Constants.UI.mediumSpacing) {
                    Image(systemName: "lock.rotation")
                        .font(.system(size: 60))
                        .foregroundColor(Constants.Colors.primaryBlue)
                    
                    Text("Новый пароль")
                        .font(Constants.Fonts.title1)
                        .foregroundColor(Constants.Colors.textPrimary)
                    
                    Text("Введите новый пароль для вашего аккаунта")
                        .font(Constants.Fonts.body)
                        .foregroundColor(Constants.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Constants.UI.padding)
                }
                
                // Form
                VStack(spacing: Constants.UI.mediumSpacing) {
                    CustomTextField(
                        placeholder: "Новый пароль",
                        text: $password,
                        icon: Constants.Images.lock,
                        isSecure: true,
                        contentType: .newPassword
                    )
                    
                    CustomTextField(
                        placeholder: "Подтвердите пароль",
                        text: $confirmPassword,
                        icon: Constants.Images.lock,
                        isSecure: true,
                        contentType: .newPassword
                    )
                    
                    // Password Requirements
                    VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
                        HStack {
                            Image(systemName: password.count >= Constants.Validation.minPasswordLength ? Constants.Images.checkmark : Constants.Images.xmark)
                                .foregroundColor(password.count >= Constants.Validation.minPasswordLength ? Constants.Colors.successGreen : Constants.Colors.errorRed)
                            Text("Минимум \(Constants.Validation.minPasswordLength) символов")
                                .font(Constants.Fonts.caption)
                        }
                        
                        HStack {
                            Image(systemName: password == confirmPassword && !confirmPassword.isEmpty ? Constants.Images.checkmark : Constants.Images.xmark)
                                .foregroundColor(password == confirmPassword && !confirmPassword.isEmpty ? Constants.Colors.successGreen : Constants.Colors.errorRed)
                            Text("Пароли совпадают")
                                .font(Constants.Fonts.caption)
                        }
                    }
                    .padding(.horizontal, Constants.UI.smallPadding)
                    
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
                    
                    // Reset Button
                    Button {
                        Task {
                            await viewModel.resetPassword(
                                token: resetToken,
                                password: password,
                                confirmPassword: confirmPassword
                            )
                            
                            if viewModel.successMessage != nil {
                                showingSuccessAlert = true
                            }
                        }
                    } label: {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .tint(.white)
                            }
                            Text("Сменить пароль")
                                .font(Constants.Fonts.headline)
                        }
                    }
                    .primaryButtonStyle()
                    .disabled(viewModel.isLoading || !isFormValid)
                    .padding(.top, Constants.UI.smallSpacing)
                }
                .padding(.horizontal, Constants.UI.largePadding)
                
                Spacer()
            }
            .navigationTitle("Смена пароля")
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
        .alert("Пароль изменен", isPresented: $showingSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Ваш пароль был успешно изменен. Теперь вы можете войти в систему с новым паролем.")
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            viewModel.clearAllMessages()
        }
    }
    
    private var isFormValid: Bool {
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        password == confirmPassword &&
        password.count >= Constants.Validation.minPasswordLength
    }
}

#Preview {
    ResetPasswordView(resetToken: "sample-token")
        .environmentObject(AuthManager())
}
