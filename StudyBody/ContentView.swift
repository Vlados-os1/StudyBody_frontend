//
// ContentView.swift
// StudyBodyApp
//
// Created by User on 25/08/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthManager()

    var body: some View {
        Group {
            if authManager.isLoading {
                LoadingView(text: "Проверка авторизации...")
            } else if authManager.isLoggedIn {
                MainTabView()
                    .environmentObject(authManager)
            } else {
                LoginView()
                    .environmentObject(authManager)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: authManager.isLoggedIn)
    }
}

#Preview {
    ContentView()
}
