//
// RootTabView.swift
// StudyBody
//

import SwiftUI

struct RootTabView: View {
    @StateObject private var userVM = UserViewModel()
    @StateObject private var vacancyVM = VacancyViewModel()
    
    var body: some View {
        TabView {
            ProfileView()
                .environmentObject(userVM)
                .tabItem {
                    Label("Профиль", systemImage: "person.circle")
                }
            
            VacancyListView()
                .environmentObject(vacancyVM)
                .tabItem {
                    Label("Вакансии", systemImage: "list.bullet.rectangle")
                }
        }
        .task {
            await userVM.fetchProfile()
            await vacancyVM.fetchVacancies()
        }
    }
}
