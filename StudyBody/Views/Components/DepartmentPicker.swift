//
// DepartmentPicker.swift
// StudyBodyApp
//
// Created by User on 25/08/2025.
//

import SwiftUI

struct DepartmentPicker: View {
    @Binding var selectedDepartment: UserDepartment?
    @State private var showingPicker = false

    var body: some View {
        Button {
            showingPicker = true
        } label: {
            HStack {
                Image(systemName: "building.2")
                    .foregroundColor(Constants.Colors.textSecondary)
                    .frame(width: 20)
                
                Text(selectedDepartment?.displayName ?? "Выберите факультет")
                    .foregroundColor(
                        selectedDepartment != nil ?
                        Constants.Colors.textPrimary :
                        Constants.Colors.textTertiary
                    )
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .foregroundColor(Constants.Colors.textSecondary)
                    .font(.caption)
            }
            .padding(Constants.UI.padding)
            .background(Constants.Colors.backgroundSecondary)
            .cornerRadius(Constants.UI.cornerRadius)
        }
        .buttonStyle(PlainButtonStyle())
        .actionSheet(isPresented: $showingPicker) {
            ActionSheet(
                title: Text("Выберите факультет"),
                buttons: departmentButtons
            )
        }
    }
    
    private var departmentButtons: [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = []
        
        // Clear selection option
        buttons.append(
            .default(Text("Не указывать")) {
                selectedDepartment = nil
            }
        )
        
        // Department options
        for department in UserDepartment.allCases {
            buttons.append(
                .default(Text(department.displayName)) {
                    selectedDepartment = department
                }
            )
        }
        
        // Cancel button
        buttons.append(.cancel())
        
        return buttons
    }
}

#Preview {
    VStack(spacing: 20) {
        DepartmentPicker(selectedDepartment: .constant(nil))
        DepartmentPicker(selectedDepartment: .constant(.iu))
    }
    .padding()
}
