//
// ProfileView.swift
// StudyBody
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var vm: UserViewModel
    @EnvironmentObject var authService: AuthService
    
    @State private var showingEdit = false
    @State private var showingLogoutConfirmation = false
    
    var body: some View {
        NavigationStack {
            if let user = vm.user {
                Form {
                    Section("Основная информация") {
                        LabeledContent("Имя", value: user.fullName)
                        LabeledContent("Email", value: user.email)
                        LabeledContent("Департамент", value: user.department?.title ?? "Не указан")
                        LabeledContent("Интересы", value: user.interests ?? "Не указаны")
                    }
                    Section("Действия") {
                        Button("Выйти из аккаунта") {
                            showingLogoutConfirmation = true
                        }
                        .foregroundColor(.red)
                    }
                }
                .navigationTitle("Профиль")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Редактировать") {
                            showingEdit = true
                        }
                    }
                }
                .sheet(isPresented: $showingEdit) {
                    EditProfileView(draft: user) { draft in
                        Task {
                            _ = await vm.saveProfile(draft)
                        }
                    }
                }
                .confirmationDialog(
                    "Выйти из аккаунта?",
                    isPresented: $showingLogoutConfirmation,
                    titleVisibility: .visible
                ) {
                    Button("Выйти", role: .destructive) {
                        Task {
                            await authService.logout()
                        }
                    }
                    Button("Отмена", role: .cancel) {}
                } message: {
                    Text("Вы уверены, что хотите выйти из аккаунта?")
                }
            } else {
                ProgressView()
                    .navigationTitle("Профиль")
            }
        }
    }
}
