import SwiftUI

struct CreateVacancyView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var tags = ""

    var onSave: (VacancyCreateRequest) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Заголовок") {
                    TextField("Название вакансии", text: $title)
                }
                Section("Описание") {
                    TextEditor(text: $description)
                        .frame(height: 120)
                }
                Section("Теги") {
                    TextField("Например: SwiftUI, CoreData, iOS", text: $tags)
                        .autocapitalization(.none)
                }
            }
            .navigationTitle("Новая вакансия")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Создать") {
                        let request = VacancyCreateRequest(
                            title: title,
                            description: description.isEmpty ? nil : description,
                            tags: tags.isEmpty ? nil : tags
                        )
                        onSave(request)
                        dismiss()
                    }
                    .disabled(title.isEmpty || description.isEmpty)
                }
            }
        }
    }
}
