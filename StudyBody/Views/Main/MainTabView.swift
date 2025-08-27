//
//  MainTabView.swift
//  StudyBodyApp
//
//  Created by User on 26/08/2025.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        TabView {
            VacanciesView()
                .tabItem {
                    Image(systemName: Constants.Images.briefcase)
                    Text("Вакансии")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: Constants.Images.personFill)
                    Text("Профиль")
                }
        }
        .accentColor(Constants.Colors.primaryBlue)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthManager())
}
