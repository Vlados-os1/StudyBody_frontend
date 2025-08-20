//
// StudyBodyApp.swift
// StudyBody
//

import SwiftUI

@main
struct StudyBodyApp: App {
    @StateObject private var authService = AuthService.shared
    @StateObject private var tokenManager = TokenManager.shared
    
    var body: some Scene {
        WindowGroup {
            AuthenticationView()
                .environmentObject(authService)
                .environmentObject(tokenManager)
        }
    }
}
