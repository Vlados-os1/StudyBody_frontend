//
// ProfileView.swift
// StudyBodyApp
//
// Created by User on 25/08/2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var viewModel: ProfileViewModel
    @State private var showingEditProfile = false
    @State private var showingChangePassword = false
    @State private var showingLogoutAlert = false
    
    init() {
        let authManager = AuthManager()
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(authManager: authManager))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Constants.UI.largeSpacing) {
                    if let user = authManager.currentUser {
                        // Profile Header
                        VStack(spacing: Constants.UI.mediumSpacing) {
                            // Avatar
                            Circle()
                                .fill(Constants.Colors.primaryBlue.opacity(0.1))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: Constants.Images.personFill)
                                        .font(.system(size: 40))
                                        .foregroundColor(Constants.Colors.primaryBlue)
                                )
                            
                            // User Name
                            Text(user.fullName)
                                .font(Constants.Fonts.title1)
                                .foregroundColor(Constants.Colors.textPrimary)
                                
                            // Email
                            Text(user.email)
                                .font(Constants.Fonts.callout)
                                .foregroundColor(Constants.Colors.textSecondary)
                        }
                        .padding(.top, Constants.UI.largePadding)
                        
                        // Profile Information
                        VStack(spacing: Constants.UI.mediumSpacing) {
                            ProfileInfoCard(
                                title: "Факультет",
                                value: user.department?.displayName ?? "Не указан",
                                icon: "building.2"
                            )
                            
                            ProfileInfoCard(
                                title: "Интересы",
                                value: user.interests ?? "Не указаны",
                                icon: "heart"
                            )
                        }
                        .padding(.horizontal, Constants.UI.largePadding)
                        
                        // Action Buttons
                        VStack(spacing: Constants.UI.mediumSpacing) {
                            Button {
                                showingEditProfile = true
                            } label: {
                                HStack {
                                    Image(systemName: Constants.Images.pencil)
                                    Text(Constants.Text.Profile.edit)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .secondaryButtonStyle()
                            
                            Button {
                                showingChangePassword = true
                            } label: {
                                HStack {
                                    Image(systemName: Constants.Images.lock)
                                    Text(Constants.Text.Profile.changePassword)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .secondaryButtonStyle()
                            
                            Button {
                                showingLogoutAlert = true
                            } label: {
                                HStack {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                    Text(Constants.Text.Profile.logout)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .destructiveButtonStyle()
                        }
                        .padding(.horizontal, Constants.UI.largePadding)
                        
                    } else {
                        LoadingView(text: "Загрузка профиля...")
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle(Constants.Text.Profile.title)
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView()
        }
        .sheet(isPresented: $showingChangePassword) {
            ChangePasswordView()
        }
        .alert("Выход из аккаунта", isPresented: $showingLogoutAlert) {
            Button("Отмена", role: .cancel) { }
            Button("Выйти", role: .destructive) {
                // ИСПРАВЛЕННЫЙ ВЫЗОВ - БЕЗ Task и await
                viewModel.logout()
            }
        } message: {
            Text("Вы уверены, что хотите выйти из аккаунта?")
        }
        .refreshable {
            await authManager.loadUserProfile()
        }
    }
}

struct ProfileInfoCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Constants.Colors.primaryBlue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Constants.Fonts.caption)
                    .foregroundColor(Constants.Colors.textSecondary)
                
                Text(value)
                    .font(Constants.Fonts.body)
                    .foregroundColor(Constants.Colors.textPrimary)
            }
            
            Spacer()
        }
        .padding(Constants.UI.padding)
        .cardStyle()
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthManager())
}
