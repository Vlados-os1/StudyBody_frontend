//
// MyVacanciesView.swift
// StudyBodyApp
//
// Created by User on 25/08/2025.
//

import SwiftUI

struct MyVacanciesView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var vacancyViewModel: VacancyViewModel
    @State private var showingCreateVacancy = false
    @State private var selectedVacancy: Vacancy?
    @State private var vacancyToEdit: Vacancy?
    @State private var showingDeleteAlert = false
    @State private var vacancyToDelete: Vacancy?

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if vacancyViewModel.isLoading && vacancyViewModel.myVacancies.isEmpty {
                    LoadingView(text: "Загрузка ваших вакансий...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if vacancyViewModel.myVacancies.isEmpty {
                    EmptyMyVacanciesView(showingCreateVacancy: $showingCreateVacancy)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(vacancyViewModel.myVacancies) { vacancy in
                        MyVacancyCard(
                            vacancy: vacancy,
                            onEdit: {
                                vacancyToEdit = vacancy
                            },
                            onDelete: {
                                vacancyToDelete = vacancy
                                showingDeleteAlert = true
                            },
                            onTap: {
                                selectedVacancy = vacancy
                            }
                        )
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .padding(.horizontal, Constants.UI.padding)
                        .padding(.vertical, Constants.UI.smallPadding)
                    }
                    .listStyle(PlainListStyle())
                    .refreshable {
                        await vacancyViewModel.fetchMyVacancies()
                    }
                }

                // Error/Success Messages
                if let errorMessage = vacancyViewModel.errorMessage {
                    ErrorBannerView(
                        message: errorMessage,
                        isVisible: .constant(true)
                    )
                    .padding(.horizontal, Constants.UI.padding)
                }

                if let successMessage = vacancyViewModel.successMessage {
                    SuccessBannerView(
                        message: successMessage,
                        isVisible: .constant(true)
                    )
                    .padding(.horizontal, Constants.UI.padding)
                }
            }
            .navigationTitle(Constants.Text.Vacancies.myVacancies)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingCreateVacancy = true
                    } label: {
                        Image(systemName: Constants.Images.plus)
                            .foregroundColor(Constants.Colors.primaryBlue)
                    }
                }
            }
        }
        .sheet(isPresented: $showingCreateVacancy) {
            CreateVacancyView()
        }
        .sheet(item: $vacancyToEdit) { vacancy in
            EditVacancyView(vacancy: vacancy)
        }
        .sheet(item: $selectedVacancy) { vacancy in
            VacancyDetailView(vacancy: vacancy)
        }
        .alert("Удалить вакансию", isPresented: $showingDeleteAlert) {
            Button("Отмена", role: .cancel) {
                vacancyToDelete = nil
            }
            Button("Удалить", role: .destructive) {
                if let vacancy = vacancyToDelete {
                    Task {
                        await deleteVacancy(vacancy)
                    }
                }
            }
        } message: {
            if let vacancy = vacancyToDelete {
                Text("Вы уверены, что хотите удалить вакансию \"\(vacancy.title)\"?")
            }
        }
        .onAppear {
            Task {
                await vacancyViewModel.fetchMyVacancies()
            }
        }
    }

    private func deleteVacancy(_ vacancy: Vacancy) async {
        await vacancyViewModel.deleteVacancy(id: vacancy.id)
        vacancyToDelete = nil
    }
}

struct EmptyMyVacanciesView: View {
    @Binding var showingCreateVacancy: Bool
    
    var body: some View {
        VStack(spacing: Constants.UI.mediumSpacing) {
            Image(systemName: Constants.Images.briefcaseFill)
                .font(.system(size: 60))
                .foregroundColor(Constants.Colors.textTertiary)
            
            Text("У вас нет вакансий")
                .font(Constants.Fonts.title2)
                .foregroundColor(Constants.Colors.textSecondary)
            
            Text("Создайте первую вакансию, чтобы начать поиск сотрудников")
                .font(Constants.Fonts.body)
                .foregroundColor(Constants.Colors.textTertiary)
                .multilineTextAlignment(.center)
            
            Button {
                showingCreateVacancy = true
            } label: {
                Text("Создать вакансию")
                    .font(Constants.Fonts.headline)
            }
            .primaryButtonStyle()
            .padding(.top, Constants.UI.mediumSpacing)
        }
        .padding(Constants.UI.largePadding)
    }
}

struct MyVacancyCard: View {
    let vacancy: Vacancy
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
            // Header with title and menu
            HStack {
                Text(vacancy.title)
                    .font(Constants.Fonts.headline)
                    .foregroundColor(Constants.Colors.textPrimary)
                    .lineLimit(2)
                
                Spacer()
                
                Menu {
                    Button {
                        onEdit()
                    } label: {
                        Label("Редактировать", systemImage: Constants.Images.pencil)
                    }
                    
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Label("Удалить", systemImage: Constants.Images.trash)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(Constants.Colors.textSecondary)
                }
            }
            
            // Description
            if let description = vacancy.description, !description.isEmpty {
                Text(description)
                    .font(Constants.Fonts.body)
                    .foregroundColor(Constants.Colors.textSecondary)
                    .lineLimit(3)
            }
            
            // Tags
            if let tags = vacancy.tags, !tags.isEmpty {
                TagsView(tags: tags.components(separatedBy: ","))
            }
            
            // Footer
            HStack {
                Text(vacancy.createdAt?.timeAgo() ?? "")
                    .font(Constants.Fonts.caption)
                    .foregroundColor(Constants.Colors.textTertiary)
                
                Spacer()
            }
        }
        .padding(Constants.UI.padding)
        .cardStyle()
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    MyVacanciesView()
        .environmentObject(AuthManager())
        .environmentObject(VacancyViewModel())
}
