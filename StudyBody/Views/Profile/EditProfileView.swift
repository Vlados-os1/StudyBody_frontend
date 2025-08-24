//
// EditProfileView.swift
// StudyBody
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var draft: User

    var onSave: (User) -> Void

    init(draft: User, onSave: @escaping (User) -> Void) {
        _draft = State(initialValue: draft)
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Департамент") {
                    Picker("Департамент", selection: $draft.department) {
                        Text("Не выбран").tag(nil as UserDepartment?)
                        ForEach(UserDepartment.allCases) { department in
                            Text(department.title).tag(department as UserDepartment?)
                        }
                    }
                }

                Section("Интересы") {
                    TextField("Интересы", text: Binding(
                        get: { draft.interests ?? "" },
                        set: { draft.interests = $0.isEmpty ? nil : $0 }
                    ))
                    .frame(height: 120)
                }
            }
            .navigationTitle("Редактирование")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена", role: .cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        onSave(draft)
                        dismiss()
                    }
                }
            }
        }
    }
}
