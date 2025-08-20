//
// CreateVacancyView.swift
// StudyBody
//

import SwiftUI

struct CreateVacancyView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var summary = ""
    @State private var tags = ""
    
    var onSave: (Vacancy) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Заголовок") {
                    TextField("Название вакансии", text: $title)
                }
                
                Section("Описание") {
                    TextEditor(text: $summary)
                        .frame(height: 120)
                }
                
                Section("Теги через запятую") {
                    TextField("пример: SwiftUI, CoreData", text: $tags)
                }
            }
            .navigationTitle("Новая вакансия")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let vacancy = Vacancy(
                            id: .init(),
                            title: title,
                            summary: summary,
                            authorName: "Me", // TODO: заменить на текущего пользователя
                            createdAt: Date(),
                            tags: tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                        )
                        onSave(vacancy)
                        dismiss()
                    }
                    .disabled(title.isEmpty || summary.isEmpty)
                }
            }
        }
    }
}
