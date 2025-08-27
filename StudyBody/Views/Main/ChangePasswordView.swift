//
//  ChangePasswordView.swift
//  StudyBodyApp
//
//  Created by User on 25/08/2025.
//

import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var viewModel: ProfileViewModel
    
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showingSuccessAlert = false
    
    init() {
        let authManager = AuthManager()
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(authManager: authManager))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Constants.UI.largeSpacing) {
                    // Header
                    VStack(spacing: Constants.UI.mediumSpacing) {
                        Image(systemName: "lock.rotation")
                            .font(.system(size: 60))
                            .foregroundColor(Constants.Colors.primaryBlue)
                        
                        Text("Смена пароля")
                            .font(Constants.Fonts.title1)
                            .foregroundColor(Constants.Colors.textPrimary)
                        
                        Text("Для безопасности введите текущий пароль и новый пароль")
                            .font(Constants.Fonts.body)
                            .foregroundColor(Constants.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Constants.UI.padding)
                    }
                    .padding(.top, Constants.UI.padding)
                    
                    // Password Form
                    VStack(spacing: Constants.UI.mediumSpacing) {
                        CustomTextField(
                            placeholder: "Текущий пароль",
                            text: $oldPassword,
                            icon: Constants.Images.lock,
                            isSecure: true,
                            contentType: .password
                        )
                        
                        CustomTextField(
                            placeholder: "Новый пароль",
                            text: $newPassword,
                            icon: Constants.Images.lock,
                            isSecure: true,
                            contentType: .newPassword
                        )
                        
                        CustomTextField(
                            placeholder: "Подтвердите новый пароль",
                            text: $confirmPassword,
                            icon: Constants.Images.lock,
                            isSecure: true,
                            contentType: .newPassword
                        )
                        
                        // Password Requirements
                        VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
                            HStack {
                                Image(systemName: newPassword.count >= Constants.Validation.minPasswordLength ? Constants.Images.checkmark : Constants.Images.xmark)
                                    .foregroundColor(newPassword.count >= Constants.Validation.minPasswordLength ? Constants.Colors.successGreen : Constants.Colors.errorRed)
                                Text("Минимум \(Constants.Validation.minPasswordLength) символов")
                                    .font(Constants.Fonts.caption)
                            }
                            
                            HStack {
                                Image(systemName: newPassword == confirmPassword && !confirmPassword.isEmpty ? Constants.Images.checkmark : Constants.Images.xmark)
                                    .foregroundColor(newPassword == confirmPassword && !confirmPassword.isEmpty ? Constants.Colors.successGreen : Constants.Colors.errorRed)
                                Text("Пароли совпадают")
                                    .font(Constants.Fonts.caption)
                            }
                            
                            HStack {
                                Image(systemName: newPassword != oldPassword && !newPassword.isEmpty ? Constants.Images.checkmark : Constants.Images.xmark)
                                    .foregroundColor(newPassword != oldPassword && !newPassword.isEmpty ? Constants.Colors.successGreen : Constants.Colors.errorRed)
                                Text("Новый пароль отличается от текущего")
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
                        
                        // Change Password Button
                        Button {
                            Task {
                                await changePassword()
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
            }
            .navigationTitle("Смена пароля")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(Constants.Text.Common.cancel) {
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
            Text("Ваш пароль был успешно изменен")
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            viewModel.clearAllMessages()
        }
    }
    
    private var isFormValid: Bool {
        !oldPassword.isEmpty &&
        !newPassword.isEmpty &&
        !confirmPassword.isEmpty &&
        newPassword == confirmPassword &&
        newPassword != oldPassword &&
        newPassword.count >= Constants.Validation.minPasswordLength
    }
    
    private func changePassword() async {
        await viewModel.changePassword(
            oldPassword: oldPassword,
            newPassword: newPassword,
            confirmPassword: confirmPassword
        )
        
        if viewModel.successMessage != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showingSuccessAlert = true
            }
        }
    }
}

#Preview {
    ChangePasswordView()
        .environmentObject(AuthManager())
}
