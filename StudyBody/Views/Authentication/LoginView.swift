//
// LoginView.swift
// StudyBody
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @FocusState private var focusedField: Field?
    
    let onSwitchToRegister: () -> Void
    let onLoginSuccess: () -> Void
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    loginFormSection
                    loginButtonSection
                    forgotPasswordSection
                    switchToRegisterSection
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
            }
            .navigationBarHidden(true)
            .background(Color(.systemBackground))
            .sheet(isPresented: $viewModel.showingForgotPassword) {
                ForgotPasswordView()
            }
            .alert("Ошибка", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.clearError()
                }
            } message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "graduationcap.fill")
                .font(.system(size: 64))
                .foregroundColor(.blue)
            
            Text("StudyBody")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Войдите в свой аккаунт")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 16)
        }
    }
    
    private var loginFormSection: some View {
        VStack(spacing: 16) {
            CustomTextField(
                title: "Email",
                text: $viewModel.email,
                keyboardType: .emailAddress,
                autocapitalization: .never
            )
            .focused($focusedField, equals: .email)
            .onSubmit { focusedField = .password }
            
            CustomTextField(
                title: "Пароль",
                text: $viewModel.password,
                isSecure: true
            )
            .focused($focusedField, equals: .password)
            .onSubmit {
                if viewModel.isFormValid {
                    Task { await viewModel.login() }
                }
            }
        }
    }
    
    private var loginButtonSection: some View {
        LoadingButton(
            title: "Войти",
            isLoading: viewModel.isLoading,
            isEnabled: viewModel.isFormValid
        ) {
            Task { await viewModel.login() }
        }
        .padding(.top, 8)
    }
    
    private var forgotPasswordSection: some View {
        Button("Забыли пароль?") {
            viewModel.showingForgotPassword = true
        }
        .font(.subheadline)
        .foregroundColor(.blue)
    }
    
    private var switchToRegisterSection: some View {
        VStack(spacing: 8) {
            Text("Нет аккаунта?")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button("Зарегистрироваться") {
                onSwitchToRegister()
            }
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.blue)
            .padding(.top, 16)
        }
    }
}
