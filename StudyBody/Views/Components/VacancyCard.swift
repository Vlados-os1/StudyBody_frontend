//
// VacancyCard.swift
// StudyBodyApp
//
// Created by User on 25/08/2025.
//

import SwiftUI

struct VacancyCard: View {
    let vacancy: Vacancy
    let canEdit: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
            // Header with author info
            HStack {
                Circle()
                    .fill(Constants.Colors.primaryBlue.opacity(0.1))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: Constants.Images.personFill)
                            .font(.system(size: 14))
                            .foregroundColor(Constants.Colors.primaryBlue)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(vacancy.user.fullName)
                        .font(Constants.Fonts.callout)
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
                
                if canEdit {
                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .foregroundColor(Constants.Colors.successGreen)
                        .font(.caption)
                }
            }
            
            // Title
            Text(vacancy.title)
                .font(Constants.Fonts.headline)
                .foregroundColor(Constants.Colors.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                
            // Description
            if let description = vacancy.description, !description.isEmpty {
                Text(description)
                    .font(Constants.Fonts.body)
                    .foregroundColor(Constants.Colors.textSecondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
            
            // Tags
            if let tags = vacancy.tags, !tags.isEmpty {
                TagsView(tags: tags.components(separatedBy: ","))
            }
        }
        .padding(Constants.UI.padding)
        .cardStyle()
    }
}

#Preview {
    VStack {
        Text("Preview недоступен")
    }
    .padding()
}
