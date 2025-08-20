//
// VacancyDetailView.swift
// StudyBody
//

import SwiftUI

struct VacancyDetailView: View {
    let vacancy: Vacancy
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(vacancy.title)
                    .font(.title2)
                    .bold()
                
                Text("Автор: \(vacancy.authorName)")
                    .foregroundColor(.secondary)
                
                Text(vacancy.summary)
                    .font(.body)
                
                if !vacancy.tags.isEmpty {
                    Text("Теги: " + vacancy.tags.joined(separator: ", "))
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .navigationTitle("Подробности")
    }
}
