//
// VacancyDetailView.swift
// StudyBodyApp
//
// Created by User on 25/08/2025.
//

import SwiftUI

struct VacancyDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var vacancyViewModel: VacancyViewModel
    
    let vacancy: Vacancy
    @State private var showingEditVacancy = false
    @State private var showingDeleteAlert = false
    
    var canEdit: Bool {
        if let currentUser = authManager.currentUser {
            return vacancy.user.id == currentUser.id
        }
        return false
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: Constants.UI.largeSpacing) {
                    // Header
                    headerSection
                    
                    Divider()
                        .padding(.horizontal, Constants.UI.largePadding)
                    
                    // Content
                    contentSection
                    
                    Spacer(minLength: Constants.UI.largePadding)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Закрыть") {
                        dismiss()
                    }
                    .foregroundColor(Constants.Colors.primaryBlue)
                }
                
                if canEdit {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            editButton
                            deleteButton
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundColor(Constants.Colors.primaryBlue)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditVacancy) {
            EditVacancyView(vacancy: vacancy)
        }
        .alert("Удалить вакансию", isPresented: $showingDeleteAlert) {
            Button("Отмена", role: .cancel) { }
            Button("Удалить", role: .destructive) {
                Task {
                    let success = await vacancyViewModel.deleteVacancy(id: vacancy.id)
                    if success {
                        dismiss()
                    }
                }
            }
        } message: {
            Text("Вы уверены, что хотите удалить эту вакансию?")
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: Constants.UI.mediumSpacing) {
            Text(vacancy.title)
                .font(Constants.Fonts.largeTitle)
                .foregroundColor(Constants.Colors.textPrimary)
                .multilineTextAlignment(.leading)
            
            // Author info
            HStack {
                Circle()
                    .fill(Constants.Colors.primaryBlue.opacity(0.1))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: Constants.Images.personFill)
                            .font(.system(size: 18))
                            .foregroundColor(Constants.Colors.primaryBlue)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(vacancy.user.fullName)
                        .font(Constants.Fonts.headline)
                        .foregroundColor(Constants.Colors.textPrimary)
                    
                    HStack {
                        if let department = vacancy.user.department {
                            Text(department.displayName)
                                .font(Constants.Fonts.caption)
                                .foregroundColor(Constants.Colors.textSecondary)
                        }
                        
                        if vacancy.user.department != nil {
                            Text("•")
                                .font(Constants.Fonts.caption)
                                .foregroundColor(Constants.Colors.textTertiary)
                        }
                        
                        Text(vacancy.createdAt?.timeAgo() ?? "")
                            .font(Constants.Fonts.caption)
                            .foregroundColor(Constants.Colors.textSecondary)
                    }
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, Constants.UI.largePadding)
        .padding(.top, Constants.UI.mediumSpacing)
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: Constants.UI.largeSpacing) {
            // Description
            if let description = vacancy.description, !description.isEmpty {
                VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
                    Text("Описание")
                        .font(Constants.Fonts.title3)
                        .foregroundColor(Constants.Colors.textPrimary)
                    
                    Text(description)
                        .font(Constants.Fonts.body)
                        .foregroundColor(Constants.Colors.textSecondary)
                        .lineSpacing(4)
                }
            }
            
            // Tags
            if let tags = vacancy.tags, !tags.isEmpty {
                VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
                    Text("Теги")
                        .font(Constants.Fonts.title3)
                        .foregroundColor(Constants.Colors.textPrimary)
                    
                    TagsView(tags: tags.components(separatedBy: ","))
                }
            }
            
            // Contact Info
            VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
                Text("Контактная информация")
                    .font(Constants.Fonts.title3)
                    .foregroundColor(Constants.Colors.textPrimary)
                
                HStack {
                    Image(systemName: Constants.Images.envelope)
                        .foregroundColor(Constants.Colors.primaryBlue)
                        .frame(width: 20)
                    
                    Text(vacancy.user.email)
                        .font(Constants.Fonts.body)
                        .foregroundColor(Constants.Colors.textPrimary)
                    
                    Spacer()
                    
                    Button {
                        if let url = URL(string: "mailto:\(vacancy.user.email)") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("Написать")
                            .font(Constants.Fonts.caption)
                            .foregroundColor(Constants.Colors.primaryBlue)
                            .padding(.horizontal, Constants.UI.smallPadding)
                            .padding(.vertical, 4)
                            .background(Constants.Colors.primaryBlue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding(Constants.UI.padding)
                .cardStyle()
            }
            
            // Interests (if available)
            if let interests = vacancy.user.interests, !interests.isEmpty {
                VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
                    Text("Интересы автора")
                        .font(Constants.Fonts.title3)
                        .foregroundColor(Constants.Colors.textPrimary)
                    
                    Text(interests)
                        .font(Constants.Fonts.body)
                        .foregroundColor(Constants.Colors.textSecondary)
                        .lineSpacing(2)
                }
            }
        }
        .padding(.horizontal, Constants.UI.largePadding)
    }
    
    private var editButton: some View {
        Button {
            showingEditVacancy = true
        } label: {
            Label("Редактировать", systemImage: Constants.Images.pencil)
        }
    }
    
    private var deleteButton: some View {
        Button(role: .destructive) {
            showingDeleteAlert = true
        } label: {
            Label("Удалить", systemImage: Constants.Images.trash)
        }
    }
}

#Preview {
    Text("Preview недоступен")
}
