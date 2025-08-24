import Foundation

struct Vacancy: Codable, Identifiable, Hashable {
    var id: UUID
    var title: String
    var description: String
    var tags: String
    var createdAt: Date
    var updatedAt: Date
    var user: VacancyAuthor

    enum CodingKeys: String, CodingKey {
        case id, title, description, tags, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    var summary: String { description }
    var authorName: String { user.fullName }
    var tagsArray: [String] {
        tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
    }
    
    static let preview = Vacancy(
        id: UUID(),
        title: "Мобильная команда для pet-проекта",
        description: "Ищем iOS-разработчика в команду приложения для учёта тренировок.",
        tags: "Health, SwiftUI, iOS",
        createdAt: Date(),
        updatedAt: Date(),
        user: VacancyAuthor(
            email: "anna@example.com",
            fullName: "Анна Петрова",
            department: .iu,
            interests: "iOS разработка"
        )
    )
}

struct VacancyAuthor: Codable, Hashable {
    let email: String
    let fullName: String
    let department: UserDepartment?
    let interests: String?
    
    enum CodingKeys: String, CodingKey {
        case email, department, interests
        case fullName = "full_name"
    }
}

struct VacancyCreateRequest: Codable {
    let title: String
    let description: String?
    let tags: String?
}

struct VacancyUpdateRequest: Codable {
    let title: String?
    let description: String?
    let tags: String?
}
