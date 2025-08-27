//
//  EditProfileView.swift
//  StudyBodyApp
//
//  Created by User on 25/08/2025.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var viewModel: ProfileViewModel
    
    @State private var selectedDepartment: UserDepartment?
    @State private var interests: String = ""
    @State private var showingSuccessAlert = false
    
    init() {
        let authManager = AuthManager()
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(authManager: authManager))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Constants.UI.largeSpacing) {
                    if let user = authManager.currentUser {
                        // Header
                        VStack(spacing: Constants.UI.mediumSpacing) {
                            Circle()
                                .fill(Constants.Colors.primaryBlue.opacity(0.1))
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image(systemName: Constants.Images.personFill)
                                        .font(.system(size: 30))
                                        .foregroundColor(Constants.Colors.primaryBlue)
                                )
                            
                            VStack(spacing: 4) {
                                Text(user.fullName)
                                    .font(Constants.Fonts.title2)
                                    .foregroundColor(Constants.Colors.textPrimary)
                                
                                Text(user.email)
                                    .font(Constants.Fonts.callout)
                                    .foregroundColor(Constants.Colors.textSecondary)
                            }
                        }
                        .padding(.top, Constants.UI.padding)
                        
                        // Edit Form
                        VStack(spacing: Constants.UI.mediumSpacing) {
                            VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
                                Text("Факультет")
                                    .font(Constants.Fonts.headline)
                                    .foregroundColor(Constants.Colors.textPrimary)
                                
                                DepartmentPicker(selectedDepartment: $selectedDepartment)
                            }
                            
                            VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
                                Text("Интересы")
                                    .font(Constants.Fonts.headline)
                                    .foregroundColor(Constants.Colors.textPrimary)
                                
                                CustomTextArea(
                                    placeholder: "Расскажите о своих интересах, хобби, навыках...",
                                    text: $interests,
                                    maxLength: Constants.Validation.maxInterestsLength
                                )
                            }
                            
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
                        }
                        .padding(.horizontal, Constants.UI.largePadding)
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("Редактирование профиля")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(Constants.Text.Common.cancel) {
                        dismiss()
                    }
                    .foregroundColor(Constants.Colors.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Constants.Text.Common.save) {
                        Task {
                            await saveProfile()
                        }
                    }
                    .foregroundColor(Constants.Colors.primaryBlue)
                    .disabled(viewModel.isLoading)
                }
            }
        }
        .onAppear {
            setupInitialValues()
            viewModel.clearAllMessages()
        }
        .alert("Профиль обновлен", isPresented: $showingSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Изменения успешно сохранены")
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private func setupInitialValues() {
        if let user = authManager.currentUser {
            selectedDepartment = user.department
            interests = user.interests ?? ""
        }
    }
    
    private func saveProfile() async {
        await viewModel.updateProfile(
            department: selectedDepartment,
            interests: interests.isEmpty ? nil : interests
        )
        
        if viewModel.successMessage != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showingSuccessAlert = true
            }
        }
    }
}

#Preview {
    EditProfileView()
        .environmentObject(AuthManager())
}
