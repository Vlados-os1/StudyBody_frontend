//
// ForgotPasswordView.swift
// StudyBody
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var viewModel = ForgotPasswordViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isEmailFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    if viewModel.isEmailSent {
                        successSection
                    } else {
                        formSection
                        buttonSection
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
            }
            .navigationTitle("Восстановление пароля")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") { dismiss() }
                }
            }
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
            Image(systemName: "key.fill")
                .font(.system(size: 64))
                .foregroundColor(.orange)
            
            Text("Забыли пароль?")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Введите ваш email адрес и мы отправим инструкции по восстановлению пароля")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
        }
    }
    
    private var formSection: some View {
        VStack(spacing: 16) {
            CustomTextField(
                title: "Email",
                text: $viewModel.email,
                keyboardType: .emailAddress,
                autocapitalization: .never
            )
            .focused($isEmailFieldFocused)
            .onSubmit {
                if viewModel.isFormValid {
                    Task { await viewModel.sendResetEmail() }
                }
            }
        }
    }
    
    private var buttonSection: some View {
        LoadingButton(
            title: "Отправить инструкции",
            isLoading: viewModel.isLoading,
            isEnabled: viewModel.isFormValid
        ) {
            Task { await viewModel.sendResetEmail() }
        }
        .padding(.top, 8)
    }
    
    private var successSection: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.green)
            
            if let successMessage = viewModel.successMessage {
                Text(successMessage)
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Готово") { dismiss() }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding()
    }
}
