//
// Vacancy.swift
// StudyBody
//

import Foundation

struct Vacancy: Codable, Identifiable, Hashable {
    var id: UUID
    var title: String
    var summary: String
    var authorName: String
    var createdAt: Date
    var tags: [String]
    
    static let preview = Vacancy(
        id: .init(),
        title: "Мобильная команда для pet-проекта",
        summary: "Ищем iOS-разработчика в команду приложения для учёта тренировок.",
        authorName: "Анна Петрова",
        createdAt: Date(),
        tags: ["Health", "SwiftUI"]
    )
}
