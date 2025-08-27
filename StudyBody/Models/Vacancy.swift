//
// Vacancy.swift
// StudyBodyApp
//
// Created by User on 25/08/2025.
//

import Foundation

struct Vacancy: Identifiable, Codable {
    let id: String
    let title: String
    let description: String?
    let tags: String?
    let createdAt: Date?
    let updatedAt: Date?
    let user: User

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case tags
        case createdAt
        case updatedAt
        case user
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Гибкое декодирование ID
        if let idString = try? container.decode(String.self, forKey: .id) {
            id = idString
        } else if let idInt = try? container.decode(Int.self, forKey: .id) {
            id = String(idInt)
        } else {
            throw DecodingError.dataCorruptedError(forKey: .id, in: container, debugDescription: "ID field is missing or invalid")
        }
        
        // Основные поля
        title = try container.decode(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        tags = try container.decodeIfPresent(String.self, forKey: .tags)
        user = try container.decode(User.self, forKey: .user)
        
        // Гибкое декодирование дат - поддержка разных форматов
        createdAt = Self.decodeDate(from: container, forKey: .createdAt)
        updatedAt = Self.decodeDate(from: container, forKey: .updatedAt)
    }
    
    private static func decodeDate(from container: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) -> Date? {
        // Попробуем разные форматы дат
        if let dateString = try? container.decodeIfPresent(String.self, forKey: key) {
            // ISO8601 формат
            if let date = ISO8601DateFormatter().date(from: dateString) {
                return date
            }
            
            // Формат с микросекундами
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            // Простой ISO формат
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            // Формат с 'Z'
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        
        return nil
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(tags, forKey: .tags)
        try container.encode(user, forKey: .user)
        
        let formatter = ISO8601DateFormatter()
        if let createdAt = createdAt {
            try container.encode(formatter.string(from: createdAt), forKey: .createdAt)
        }
        if let updatedAt = updatedAt {
            try container.encode(formatter.string(from: updatedAt), forKey: .updatedAt)
        }
    }
}
