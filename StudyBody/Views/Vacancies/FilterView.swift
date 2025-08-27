//
// FilterView.swift
// StudyBodyApp
//
// Created by User on 25/08/2025.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDepartment: UserDepartment?

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: Constants.UI.largeSpacing) {
                // Department Filter
                VStack(alignment: .leading, spacing: Constants.UI.mediumSpacing) {
                    Text("Фильтр по факультету")
                        .font(Constants.Fonts.title2)
                        .foregroundColor(Constants.Colors.textPrimary)
                    
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: Constants.UI.smallSpacing) {
                            
                            // All departments option
                            FilterChip(
                                title: "Все факультеты",
                                isSelected: selectedDepartment == nil
                            ) {
                                selectedDepartment = nil
                            }
                            
                            // Department options
                            ForEach(UserDepartment.allCases, id: \.self) { department in
                                FilterChip(
                                    title: department.displayName,
                                    isSelected: selectedDepartment == department
                                ) {
                                    selectedDepartment = department
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, Constants.UI.largePadding)
                
                Spacer()
            }
            .navigationTitle("Фильтры")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                    .foregroundColor(Constants.Colors.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        dismiss()
                    }
                    .foregroundColor(Constants.Colors.primaryBlue)
                }
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Constants.Fonts.callout)
                .foregroundColor(isSelected ? .white : Constants.Colors.primaryBlue)
                .padding(.horizontal, Constants.UI.padding)
                .padding(.vertical, Constants.UI.smallPadding)
                .background(
                    isSelected ?
                    Constants.Colors.primaryBlue :
                    Constants.Colors.primaryBlue.opacity(0.1)
                )
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Constants.Colors.primaryBlue, lineWidth: isSelected ? 0 : 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FilterView(selectedDepartment: .constant(nil))
}
