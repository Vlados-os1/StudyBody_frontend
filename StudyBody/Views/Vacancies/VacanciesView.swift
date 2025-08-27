//
// VacanciesView.swift
// StudyBodyApp
//
// Created by User on 26/08/2025.
//

import SwiftUI

struct VacanciesView: View {
    @StateObject private var vacancyViewModel = VacancyViewModel()

    var body: some View {
        TabView {
            VacancyListView()
                .environmentObject(vacancyViewModel)
                .tabItem {
                    Image(systemName: Constants.Images.briefcase)
                    Text(Constants.Text.Vacancies.allVacancies)
                }
            
            MyVacanciesView()
                .environmentObject(vacancyViewModel)
                .tabItem {
                    Image(systemName: Constants.Images.briefcaseFill)
                    Text(Constants.Text.Vacancies.myVacancies)
                }
        }
        .accentColor(Constants.Colors.primaryBlue)
    }
}

#Preview {
    VacanciesView()
        .environmentObject(AuthManager())
}
