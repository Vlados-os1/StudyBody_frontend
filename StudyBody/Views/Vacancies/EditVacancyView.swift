//
//  EditVacancyView.swift
//  StudyBodyApp
//
//  Created by User on 25/08/2025.
//

import SwiftUI

struct EditVacancyView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var vacancyViewModel: VacancyViewModel
    
    let vacancy: Vacancy
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var tags: String = ""
    @State private var showingSuccessAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Constants.UI.largeSpacing) {
                    // Header
                    VStack(spacing: Constants.UI.mediumSpacing) {
                        Image(systemName: Constants.Images.pencil)
                            .font(.system(size: 60))
                            .foregroundColor(Constants.Colors.primaryBlue)
                        
                        Text(Constants.Text.Vacancies.editVacancy)
                            .font(Constants.Fonts.title1)
                            .foregroundColor(Constants.Colors.textPrimary)
                    }
                    .padding(.top, Constants.UI.padding)
                    
                    // Form
                    VStack(spacing: Constants.UI.mediumSpacing) {
                        CustomTextField(
                            placeholder: Constants.Text.Vacancies.titlePlaceholder,
                            text: $title.max(Constants.Validation.maxNameLength),
                            icon: Constants.Images.briefcase,
                            contentType: .none
                        )
                        
                        VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
                            Text("Описание")
                                .font(Constants.Fonts.headline)
                                .foregroundColor(Constants.Colors.textPrimary)
                            
                            CustomTextArea(
                                placeholder: Constants.Text.Vacancies.descriptionPlaceholder,
                                text: $description,
                                maxLength: Constants.Validation.maxDescriptionLength
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
                            Text("Теги")
                                .font(Constants.Fonts.headline)
                                .foregroundColor(Constants.Colors.textPrimary)
                            
                            CustomTextField(
                                placeholder: Constants.Text.Vacancies.tagsPlaceholder,
                                text: $tags.max(Constants.Validation.maxInterestsLength),
                                icon: "tag",
                                contentType: .none
                            )
                            
                            Text("Разделяйте теги запятыми, например: iOS, Swift, SwiftUI")
                                .font(Constants.Fonts.caption)
                                .foregroundColor(Constants.Colors.textTertiary)
                        }
                        
                        // Error/Success Messages
                        if let errorMessage = vacancyViewModel.errorMessage {
                            ErrorBannerView(
                                message: errorMessage,
                                isVisible: .constant(true)
                            )
                        }
                        
                        if let successMessage = vacancyViewModel.successMessage {
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
            .navigationTitle("Редактирование")
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
                            await updateVacancy()
                        }
                    }
                    .foregroundColor(Constants.Colors.primaryBlue)
                    .disabled(vacancyViewModel.isLoading || title.trimmed.isEmpty || !hasChanges)
                }
            }
        }
        .alert("Вакансия обновлена", isPresented: $showingSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Изменения успешно сохранены")
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            setupInitialValues()
            vacancyViewModel.clearAllMessages()
        }
    }
    
    private var hasChanges: Bool {
        title.trimmed != vacancy.title ||
        description.trimmed != (vacancy.description ?? "") ||
        tags.trimmed != (vacancy.tags ?? "")
    }
    
    private func setupInitialValues() {
        title = vacancy.title
        description = vacancy.description ?? ""
        tags = vacancy.tags ?? ""
    }
    
    private func updateVacancy() async {
        let trimmedTitle = title.trimmed
        let trimmedDescription = description.trimmed
        let trimmedTags = tags.trimmed
        
        let tagsArray = trimmedTags.isEmpty ? [] :
            trimmedTags.components(separatedBy: ",").map { $0.trimmed }
        
        let success = await vacancyViewModel.updateVacancy(
            id: vacancy.id,
            title: trimmedTitle != vacancy.title ? trimmedTitle : nil,
            description: trimmedDescription != (vacancy.description ?? "") ?
                (trimmedDescription.isEmpty ? nil : trimmedDescription) : nil,
            tags: trimmedTags != (vacancy.tags ?? "") ?
                (tagsArray.isEmpty ? [] : tagsArray) : nil
        )
        
        if success {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showingSuccessAlert = true
            }
        }
    }
}
