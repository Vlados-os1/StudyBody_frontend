//
// RegisterView.swift
// StudyBody
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @FocusState private var focusedField: Field?
    
    let onSwitchToLogin: () -> Void
    let onRegisterSuccess: () -> Void
    
    enum Field {
        case name, email, password, confirmPassword, interests
    }
    
    @State private var waitingForVerification = false
    
    var body: some View {
        NavigationView {
            Group {
                if waitingForVerification {
                    EmailVerificationView(email: viewModel.email)
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            headerSection
                            registerFormSection
                            registerButtonSection
                            switchToLoginSection
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 32)
                    }
                }
            }
            .navigationBarHidden(true)
            .background(Color(.systemBackground))
            .alert("Ошибка", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { viewModel.clearError() }
            } message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.badge.plus")
                .font(.system(size: 64))
                .foregroundColor(.green)
            
            Text("Создать аккаунт")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Присоединяйтесь к StudyBody")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 16)
        }
    }
    
    private var registerFormSection: some View {
        VStack(spacing: 16) {
            CustomTextField(
                title: "Имя",
                text: $viewModel.name
            )
            .focused($focusedField, equals: .name)
            .onSubmit { focusedField = .email }
            
            CustomTextField(
                title: "Email",
                text: $viewModel.email,
                keyboardType: .emailAddress,
                autocapitalization: .never
            )
            .focused($focusedField, equals: .email)
            .onSubmit { focusedField = .password }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Департамент")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Picker("Департамент", selection: $viewModel.department) {
                    Text("Не выбран").tag(nil as UserDepartment?)
                    ForEach(UserDepartment.allCases) { department in
                        Text(department.title).tag(department as UserDepartment?)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            CustomTextField(
                title: "Пароль",
                text: $viewModel.password,
                isSecure: true,
                validationMessage: viewModel.passwordValidationMessage
            )
            .focused($focusedField, equals: .password)
            .onSubmit { focusedField = .confirmPassword }
            
            CustomTextField(
                title: "Подтвердите пароль",
                text: $viewModel.confirmPassword,
                isSecure: true,
                validationMessage: viewModel.confirmPasswordValidationMessage
            )
            .focused($focusedField, equals: .confirmPassword)
            .onSubmit { focusedField = .interests }
            
            CustomTextField(
                title: "Интересы",
                text: $viewModel.interests,
                placeholder: "Например: SwiftUI, дизайн, спорт"
            )
            .focused($focusedField, equals: .interests)
            .onSubmit {
                if viewModel.isFormValid {
                    Task { await registerAction() }
                }
            }
        }
    }
    
    private var registerButtonSection: some View {
        LoadingButton(
            title: "Зарегистрироваться",
            isLoading: viewModel.isLoading,
            isEnabled: viewModel.isFormValid
        ) {
            Task { await registerAction() }
        }
        .padding(.top, 8)
    }
    
    private var switchToLoginSection: some View {
        VStack(spacing: 8) {
            Text("Уже есть аккаунт?")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button("Войти") {
                onSwitchToLogin()
            }
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.blue)
            .padding(.top, 16)
        }
    }
    
    @MainActor
    private func registerAction() async {
        await viewModel.register()
        if viewModel.errorMessage == nil {
            waitingForVerification = true
        }
    }
}
