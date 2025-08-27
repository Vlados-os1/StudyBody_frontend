//
//  VacancyListView.swift
//  StudyBodyApp
//
//  Created by User on 25/08/2025.
//

import SwiftUI

struct VacancyListView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var vacancyViewModel: VacancyViewModel
    
    @State private var searchText = ""
    @State private var selectedDepartment: UserDepartment?
    @State private var showingFilter = false
    @State private var selectedVacancy: Vacancy?
    
    var filteredVacancies: [Vacancy] {
        var vacancies = vacancyViewModel.allVacancies
        
        // Apply search filter
        if !searchText.isEmpty {
            vacancies = vacancyViewModel.searchVacancies(query: searchText)
        }
        
        // Apply department filter
        if let department = selectedDepartment {
            vacancies = vacancies.filter { $0.user.department == department }
        }
        
        return vacancies.sorted { $0.createdAt ?? Date() > $1.createdAt ?? Date() }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $searchText)
                    .padding(.horizontal, Constants.UI.padding)
                
                // Content
                if vacancyViewModel.isLoading && vacancyViewModel.allVacancies.isEmpty {
                    LoadingView(text: "Загрузка вакансий...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if filteredVacancies.isEmpty {
                    EmptyVacanciesView(
                        isSearching: !searchText.isEmpty || selectedDepartment != nil
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(filteredVacancies) { vacancy in
                        VacancyCard(
                            vacancy: vacancy,
                            canEdit: vacancyViewModel.canEditVacancy(
                                vacancy,
                                currentUserId: authManager.currentUser?.id
                            )
                        )
                        .onTapGesture {
                            selectedVacancy = vacancy
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .padding(.horizontal, Constants.UI.padding)
                        .padding(.vertical, Constants.UI.smallPadding)
                    }
                    .listStyle(PlainListStyle())
                    .refreshable {
                        await vacancyViewModel.fetchAllVacancies()
                    }
                }
                
                // Error Message
                if let errorMessage = vacancyViewModel.errorMessage {
                    ErrorBannerView(
                        message: errorMessage,
                        isVisible: .constant(true)
                    )
                    .padding(.horizontal, Constants.UI.padding)
                }
            }
            .navigationTitle(Constants.Text.Vacancies.allVacancies)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingFilter = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(Constants.Colors.primaryBlue)
                    }
                }
            }
            .sheet(isPresented: $showingFilter) {
                FilterView(selectedDepartment: $selectedDepartment)
            }
            .sheet(item: $selectedVacancy) { vacancy in
                VacancyDetailView(vacancy: vacancy)
            }
        }
        .onAppear {
            Task {
                await vacancyViewModel.fetchAllVacancies()
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: Constants.Images.magnifyingglass)
                .foregroundColor(Constants.Colors.textSecondary)
            
            TextField(Constants.Text.Vacancies.search, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: Constants.Images.xmark)
                        .foregroundColor(Constants.Colors.textSecondary)
                }
            }
        }
        .padding(Constants.UI.padding)
        .background(Constants.Colors.backgroundSecondary)
        .cornerRadius(Constants.UI.cornerRadius)
        .padding(.vertical, Constants.UI.smallPadding)
    }
}

struct EmptyVacanciesView: View {
    let isSearching: Bool
    
    var body: some View {
        VStack(spacing: Constants.UI.mediumSpacing) {
            Image(systemName: Constants.Images.briefcase)
                .font(.system(size: 60))
                .foregroundColor(Constants.Colors.textTertiary)
            
            Text(isSearching ? "Ничего не найдено" : "Нет вакансий")
                .font(Constants.Fonts.title2)
                .foregroundColor(Constants.Colors.textSecondary)
            
            Text(isSearching ?
                 "Попробуйте изменить параметры поиска" :
                 "Пока нет доступных вакансий")
                .font(Constants.Fonts.body)
                .foregroundColor(Constants.Colors.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(Constants.UI.largePadding)
    }
}

#Preview {
    VacancyListView()
        .environmentObject(AuthManager())
        .environmentObject(VacancyViewModel())
}
