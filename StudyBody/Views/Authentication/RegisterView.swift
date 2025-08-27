//
//  RegisterView.swift
//  StudyBodyApp
//
//  Created by User on 25/08/2025.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var viewModel: AuthViewModel
    
    @State private var email: String = ""
    @State private var fullName: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var selectedDepartment: UserDepartment?
    @State private var interests: String = ""
    
    init() {
        let authManager = AuthManager()
        self._viewModel = StateObject(wrappedValue: AuthViewModel(authManager: authManager))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Constants.UI.largeSpacing) {
                    // Header
                    VStack(spacing: Constants.UI.mediumSpacing) {
                        Image(systemName: Constants.Images.personCircle)
                            .font(.system(size: 60))
                            .foregroundColor(Constants.Colors.primaryBlue)
                        
                        Text(Constants.Text.Register.title)
                            .font(Constants.Fonts.title1)
                            .foregroundColor(Constants.Colors.textPrimary)
                    }
                    .padding(.top, Constants.UI.padding)
                    
                    // Registration Form
                    VStack(spacing: Constants.UI.mediumSpacing) {
                        CustomTextField(
                            placeholder: Constants.Text.Register.fullNamePlaceholder,
                            text: $fullName,
                            icon: Constants.Images.personFill,
                            contentType: .name
                        )
                        
                        CustomTextField(
                            placeholder: Constants.Text.Register.emailPlaceholder,
                            text: $email,
                            icon: Constants.Images.envelope,
                            keyboardType: .emailAddress,
                            contentType: .emailAddress
                        )
                        
                        CustomTextField(
                            placeholder: Constants.Text.Register.passwordPlaceholder,
                            text: $password,
                            icon: Constants.Images.lock,
                            isSecure: true,
                            contentType: .newPassword
                        )
                        
                        CustomTextField(
                            placeholder: Constants.Text.Register.confirmPasswordPlaceholder,
                            text: $confirmPassword,
                            icon: Constants.Images.lock,
                            isSecure: true,
                            contentType: .newPassword
                        )
                        
                        DepartmentPicker(selectedDepartment: $selectedDepartment)
                        
                        CustomTextArea(
                            placeholder: Constants.Text.Register.interestsPlaceholder,
                            text: $interests,
                            maxLength: Constants.Validation.maxInterestsLength
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
                        
                        // Register Button
                        Button {
                            Task {
                                await viewModel.register(
                                    email: email,
                                    fullName: fullName,
                                    password: password,
                                    confirmPassword: confirmPassword,
                                    department: selectedDepartment,
                                    interests: interests.isEmpty ? nil : interests
                                )
                            }
                        } label: {
                            HStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .tint(.white)
                                }
                                Text(Constants.Text.Register.registerButton)
                                    .font(Constants.Fonts.headline)
                            }
                        }
                        .primaryButtonStyle()
                        .disabled(viewModel.isLoading || !isFormValid)
                        .padding(.top, Constants.UI.smallSpacing)
                    }
                    .padding(.horizontal, Constants.UI.largePadding)
                    
                    Spacer()
                    
                    // Login Link
                    VStack(spacing: Constants.UI.smallSpacing) {
                        Text(Constants.Text.Register.haveAccount)
                            .font(Constants.Fonts.subheadline)
                            .foregroundColor(Constants.Colors.textSecondary)
                        
                        Button(Constants.Text.Register.login) {
                            dismiss()
                        }
                        .font(Constants.Fonts.headline)
                        .foregroundColor(Constants.Colors.primaryBlue)
                    }
                    .padding(.bottom, Constants.UI.largePadding)
                }
            }
            .navigationTitle(Constants.Text.Register.title)
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
    
    private var isFormValid: Bool {
        !email.isEmpty &&
        !fullName.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        password == confirmPassword &&
        password.count >= Constants.Validation.minPasswordLength
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthManager())
}
