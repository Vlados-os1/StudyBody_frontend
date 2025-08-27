//
//  LoginView.swift
//  StudyBodyApp
//
//  Created by User on 26/08/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var showingRegistration = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: Constants.UI.largeSpacing) {
                Spacer()
                
                // Logo/Title
                VStack(spacing: Constants.UI.mediumSpacing) {
                    Text("StudyBody")
                        .font(Constants.Fonts.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Constants.Colors.primaryBlue)
                    
                    Text("Добро пожаловать!")
                        .font(Constants.Fonts.title2)
                        .foregroundColor(Constants.Colors.textSecondary)
                }
                
                Spacer()
                
                // Form
                VStack(spacing: Constants.UI.mediumSpacing) {
                    CustomTextField(
                        placeholder: "Email",
                        text: $email,
                        icon: Constants.Images.envelope,
                        keyboardType: .emailAddress,
                        contentType: .emailAddress
                    )
                    
                    CustomTextField(
                        placeholder: "Пароль",
                        text: $password,
                        icon: Constants.Images.lock,
                        isSecure: true,
                        contentType: .password
                    )
                    
                    Button("Войти") {
                        Task {
                            await authManager.login(email: email, password: password)
                        }
                    }
                    .primaryButtonStyle()
                    .disabled(authManager.isLoading)
                    
                    if let errorMessage = authManager.errorMessage {
                        Text(errorMessage)
                            .font(Constants.Fonts.caption)
                            .foregroundColor(Constants.Colors.errorRed)
                            .multilineTextAlignment(.center)
                    }
                }
                
                Spacer()
                
                // Registration link
                Button("Нет аккаунта? Зарегистрироваться") {
                    showingRegistration = true
                }
                .font(Constants.Fonts.callout)
                .foregroundColor(Constants.Colors.primaryBlue)
            }
            .padding(Constants.UI.largePadding)
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingRegistration) {
            RegisterView()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager())
}
